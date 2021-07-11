# Migration & Diif path script 

## Requirement
1. Linux Base OS
2. rsync command
* RHEL / Centos 
 ```
 yum intall rsync -y 
 ```
* Ubuntu / Debian 
```
apt-get install rsync -y
```
3. Dest host need set authorized_keys for login without password

## Usage 

```
# sh migration_cdsw.sh --help
Usage: lib.sh [-h] -p param_value arg1 [arg2...]

Script description here.

Available options:

-h, --help            Print this help and exit
-m, --mode sync|diff  Two mode
		      sync mode: sync data to destination
		      diff mode: compare data between source and destination
-s, --source          Source path
-d, --destination     Destination path

Example:
sync:
    sh migration_cdsw.sh -m sync -s <source folder> -d root@<IP>:<Dest folder>
diff:
    sh migration_cdsw.sh -m diff -s <source folder> -d root@<IP>:<Dest folder>

```

## TODO list

* [ ] Account can change, now only can use root
* [ ] Auto check /tmp path  size to store diff log
* [ ] Add pem option, can use pem file login without password
