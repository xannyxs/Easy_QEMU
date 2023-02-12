# easy_qemu

<b>easy_qemu is a simple bash script that automates the process of creating and starting virtual machines using QEMU.
The script has several functions that allow you to create and manage snapshots,
create new virtual machines, start existing virtual machines, and list snapshots.</b>

### Installation - 🛠

Clone the repository to your local machine:

`git clone https://github.com/xvoorvaa/easy_qemu.git`

### Usage - ⌨️

```
./easy_qemu.sh create - Create a new qcow2 file
./easy_qemu.sh start [QCOW2 FILE] [ISO] - Start the virtual machine with a specific file
./easy_qemu.sh snapshot create [SNAPSHOT_NAME] [QCOW2 FILE] - Make a snapshot
./easy_qemu.sh snapshot delete [SNAPSHOT_NAME] [QCOW2 FILE] - Delete a snapshot
./easy_qemu.sh snapshot apply [SNAPSHOT_NAME] [QCOW2 FILE] - Apply a snapshot
./easy_qemu.sh snapshot list [QCOW2 FILE] - See a list of all snapshots
```

### Create
This function creates a new qcow2 file with a specified name. If a file with the same name already exists, it will ask the user if they want to delete it.

### Start
This function starts the virtual machine with the specified qcow2 file and ISO image. It also has several options for the virtual machine such as amount of RAM, CPU cores, and connectivity options.

### Snapshot
This function allows you to create, delete, apply, and list snapshots of the virtual machine.

---

<i><b>To contribute, simply fork the repository and create a pull request with your changes.</i></b>å
