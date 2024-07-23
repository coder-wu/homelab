# Homelab

## sync

To perform synchronization between directories using [rclone](https://rclone.org/). This script is boring, and it shouldn't even exist, but [there is an interesting story behind it](https://blog.coderwu.com/en/en/just-for-fun/).

New synchronization solution is described in [Back up with rclone and alist](https://blog.coderwu.com/en/en/backup/).

### usage

1. Configure paths to be synchronized in ```${HOMELAB_HOME}/sync/config```, one path per line.

2. Run script to synchronize:
    ```
    sh ${HOMELAB_HOME}/sync/sync.sh
    ```

## ray 

Operate ray through CLI, and run ray as a background service.

### usage

1. Read comments in ```${HOMELAB_HOME}/ray/config.sh``` and set the relevant values.

2. Run ```./ray.sh -h```.



### crontab

- Update geo data on time.
    ```
    0 10 * * * ${HOMELAB_HOME}/ray/ray.sh urd
    ```
- detect network status every minute
    ```
    * * * * * ${HOMELAB_HOME}/ray/ray.sh detect
    ```

## container

Container environment.

### k8s

```yaml files``` are used to create container with k8s.

### docker

```Makefiles``` are used to create container directly with docker.
