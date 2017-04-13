#### load-libs.sh

Takes care of loading the environment and configuration files.

##### Detailed Description

* Check about the user that runs the script

    WTL can and should be managed by a simple user, we do not require it to have
    administrative powers (remember to add your user to dockergroup!).
    Running WTL as superuser can cause errors. We need to check that the scripts
    are executed by a simple user, this check is performed by:

    ```{.bash}
    # check the user that runs the script
    if [[ $(id -u) -eq 0 ]] || [[ $(id -g) -eq 0 ]] ; then
        echo "[$0] You can't be root. root has too much power."
        echo -e "\e[31mFATAL ERROR \e[0m"
        exit 1
    fi
    ```

* Checks that the script is running in the correct folder

    WTLH scripts are indended to be run from WTLH main folder, thus a correct
    folder check is performed in every script. In order to check that the
    script is running in the correct folder, we check the presence of
    particular files, such as `const.sh` or `load-libs.sh`.

    ```{.bash}
    if [[ ! -f "load-libs.sh" ]] ; then
        echo "[load-libs] : The parent script is not running inside the directory that contains load-libs.sh"
        echo -e "\e[31mFATAL ERROR \e[0m"
        exit 1
    fi
    ```

* loads `const.sh`
* checks that the config file `wtl.conf` has been properly generated,
    and loads it
* loads `wtl-event`, a script that contains the definition of the log
    library we use to have a standard way of logging, which is necessary
    for implementing a good hook system.
* checks that the cofnig file version is the correct one
* checks that the uid and the gid are the user's ones.
* creates the cache folder, if it is not present
