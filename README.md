# Homelab

## rsync

To perform synchronization between directories using rsync. This script is boring, and it shouldn't even exist, but [there is an interesting story behind it](https://blog.coderwu.com/docs/backup.html).

### usage

1. Configure paths to be synchronized in ```${HOMELAB_HOME}/rsync/config```, one path per line.

2. Run script to synchronize:
    ```
    sh ${HOMELAB_HOME}/rsync/sync.sh
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

## K8S

I use Minikube as development environment.
