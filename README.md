# control-groups

Simple FastCGI server for work with [cgroups](https://www.kernel.org/doc/Documentation/cgroups/cgroups.txt).

## Features

1. Show the list of available cgroups.
2. Show the list of tasks' PIDs attached to particular cgroup.
3. Attach a new process to particular cgroup.

## Tutorial

### List of cgroups

Request:

```
http://localhost/cgroup?list
```

Possible response:

```json
{
    "cgroups": [
        "blkio",
        "net_cls",
        "freezer",
        "devices",
        "memory",
        "cpuacct",
        "cpu",
        "cpu,cpuacct",
        "cpuset",
        "systemd"
    ]
}
```

Assumed that `/sys/fs/cgroup` exists.

### List of tasks in cgroup

Based on content of the file `/sys/fs/cgroup/NAME/tasks`, where `NAME` is the name of particular cgroup.

Request to retrieve a list of tasks in the cgroup `blkio`:

```
http://localhost/cgroup?group=blkio&tasks
```

Possible response:

```json
{
    "cgroup": "blkio",
    "tasks": [
        1,
        2,
        3,
        5,
        7,
        8,
        9,
        10,
        22,
        24,
        25,
        25927,
        25928,
        25929
    ]
}
```

### Attach task into cgroup

Based on adding of the process' PID into the file `/sys/fs/cgroup/NAME/tasks`, where `NAME` is the name of particular cgroup.

Request to attach a process with PID `345` into cgroup `blkio`:

```
http://localhost/cgroup?task=345&intogroup=blkio
```

Possible response:

```json
{
    "status": "successfully",
    "cgroup": "blkio",
    "pid": "345"
}
```

## Technical details

1. Written with ghc-7.10.2, cabal-install-1.22.6.0 and Cabal-1.22.4.0.
2. Tested with lighttpd-1.4.37 and NixOS 15.09.


