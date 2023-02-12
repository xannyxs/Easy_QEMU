#! /usr/bin/env bash

# TODO
# Check if ISO file is given, if not it should not give the -cdrom flag
# Make README.md

OSTYPE=$(uname)

function _snapshot_create()
{
  SNAPSHOT_NAME=$1
  DISK_IMAGE=$2

  qemu-img snapshot -c "$SNAPSHOT_NAME" "$DISK_IMAGE"
}

function _snapshot_delete()
{
  SNAPSHOT_NAME=$1
  DISK_IMAGE=$2

  qemu-img snapshot -d "$SNAPSHOT_NAME" "$DISK_IMAGE"
}

function _snapshot_apply()
{
  SNAPSHOT_NAME=$1
  DISK_IMAGE=$2

  qemu-img snapshot -a "$SNAPSHOT_NAME" "$DISK_IMAGE"
}

function _snapshot_list()
{
  DISK_IMAGE=$1

  qemu-img snapshot -l "$DISK_IMAGE"
}

function _create()
{
  read -p "Give a name to the qcow2 file: " FILE

  if [ -f "$FILE.qcow2" ] ; then
    echo "$FILE.qcow2 already exists."
    read -p "Are you sure you wanna delete it? [y/n]"$'\n' ANSWER
    if [ "$ANSWER" == "n" ]; then
      echo "Not deleting file $FILE.qcow2"
      exit 0
    elif [ "$ANSWER" == "y" ]; then
      rm $FILE.qcow2
      exit 0
    else
      echo "I do not understand this"
      exit 1
    fi
  fi

  echo "Creating $FILE.qcow2..."
  qemu-img create -f qcow2 $FILE.qcow2 10G > /dev/null
}

# -m - Amount of RAM
# -smp - Amount of CPU Cores
# -vga
# -enable-kvm - Kernel-based Virtual Machine (KVM) (For Linux only)
# -cdrom - The ISO needed for the qcow2. Only needs it for first installation.
# -drive - Which .qcow2 file it needs.
# -accel=hvf - KVM for MacOS
# -nic - connect between host and guest by their port numbers 
function _start()
{
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    KVM="-enable-kvm"
  elif [[ "$OSTYPE" == "Darwin"* ]]; then
    KVM="-machine type=q35,accel=hvf"
  fi

  if [[ "$2" == *".iso" ]]; then
    CDROM="-cdrom $2"
  fi
  echo Staring Virtual Machine...

  qemu-system-x86_64 \
  -m 4G \
  -smp 2 \
  -vga virtio \
  -display default,show-cursor=on \
  -usb \
  -device usb-tablet \
  -drive file=$1,if=virtio \
  -cpu host \
  -nic user,hostfwd=tcp::22-:22 \
  "$CDROM" \
  "$KVM"

}

function _help()
{
  echo "Example usage:"
  echo "./easy_qemu create - Create a new qcow2 file"
  echo "./easy_qemu start [QCOW2 FILE] [ISO] - Start the virtual machine with a specfic file"
  echo "./easy_qemu.sh snapshot create [SNAPSHOT_NAME] [QCOW2 FILE] - Make a snapshot"
  echo "./easy_qemu.sh snapshot delete [SNAPSHOT_NAME] [QCOW2 FILE] - Delete a snapshot"
  echo "./easy_qemu.sh snapshot apply [SNAPSHOT_NAME] [QCOW2 FILE] - Apply a snapshot"
  echo "./easy_qemu.sh snapshot list [QCOW2 FILE] - See a list of all snapshots"
  exit 1
}

function main()
{
  if [ "$1" == "create" ]; then
    _create
  elif [ "$1" == "snapshot" ]; then
    if [ "$2" == "create" ]; then
      _snapshot_create "$3" "$4"
    elif [ "$2" == "delete" ]; then
      _snapshot_delete "$3" "$4"
    elif [ "$2" == "apply" ]; then
      _snapshot_apply "$3" "$4"
    elif [ "$2" == "list" ]; then
      _snapshot_list "$3"
    else
      _help
    fi
  elif [ "$1" == "start" ] && [ -f "$2" ] && [ $# -eq 2 ] || [ $# -eq 3 ]; then
    _start "$2" "$3"
  else
    _help
  fi
}

# https://blog.programster.org/qemu-img-cheatsheet
main "$1" "$2" "$3" "$4"
