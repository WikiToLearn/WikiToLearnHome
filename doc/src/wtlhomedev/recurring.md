
Recurring Commands
------------------

This section describes the commands that are recurring in many scripts.

### repo-wide script beginning

Every script should start with the following commands.

#### Debugging mode
Every script starts with

```{.bash}
[[  "$WTL_SCRIPT_DEBUG" == "1" ]] && set -x
```

which enables *debug mode*, meaning that runs the script printing to standard
output every command executed, a sort of trace mode.

This variable is supposed to be set by hand directly in the terminal:

```{.bash}
export WTL_SCRIPT_DEBUG=1
```

Then run the script to inspect. Use the following command to restore
the original configuration

```{.bash}
export WTL_SCRIPT_DEBUG=0
```

#### exit on errors
As already anticipated, every script contains the line

```{.bash}
set -e
```

in order to exit immediately if a command exits with a non-zero status.
Consult `set` manpage for further information.

#### Check of how the script is run

As anticipated in `general.mdown`, all the scripts should be launched by the
user and other script with

```{.bash}
./script.sh
```

so that `$0` always contains the correct script name, since if you launch a
call a script with

```{.bash}
. ./script.sh
```

then inside `script.sh` the variable `$0` contains the caller script name,
and we do not like it.

We need a way that allows us to check if the script is launched in te correct
way, and we do this by comparing the value of `$0` with what we expect.
This check is performed by the following commands:

```{.bash}
if [[ $(basename $0) != "instance.sh" ]] ; then
    echo "Wrong way to execute instance.sh"
    exit 1
fi
```

#### Change directory to /path/to/WikiToLearnHome/

For sake of simplicity we want every script to operate inside WTLH main folder,
this is performed by changing the directory to the correct relative path of
the script to WTLH main folder Therefore if the script is contained in
WTLH main folder, we simply do

```{.bash}
cd $(dirname $(realpath $0))
```
that changes directory to the directory that contains the current script.

If the script is contained in `script` folder, we do

```{.bash}
cd $(dirname $(realpath $0))"/.."
```
that changes directory to the directory that contains the directory that
contains the current script. Ok, i guess you have understood how this works.

Lastly we perform a check to be sure that the cd has been successfull: we test
if the `const.sh` file is present, since it should be in WTLH main folder.

```{.bash}
if [[ ! -f "const.sh" ]] ; then
    echo "Error changing directory"
    exit 1
fi
```
