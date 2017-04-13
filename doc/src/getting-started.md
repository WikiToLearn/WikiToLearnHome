# Getting started

## Requirements

- [GitHub](https://github.com/) Account
- 64-Bit Computer (docker need a 64 bit system)
- GNU/Linux with docker (you can use a virtual machine, for example [VirtualBox](https://www.virtualbox.org/))
- Stable internet connection (download size can be up to 10 GB)

This procedure may fail if you have no Internet access or if the connection is filtered by firewall – this could happen in public places such as universities, libraries, airports, etc.

## Packages

* any version
    - curl
    - rsync
    - dirname
    - realpath
    - git
    - pandoc

* specific version required
    - docker ( >= 17.03.1-ce)
    - python3

#### Ubuntu/Debian prerequisites install

``` {.bash}
sudo apt-get install curl rsync coreutils realpath git python3 pandoc
```

#### Arch prerequisites install

``` {.bash}
sudo pacman -Sy curl rsync coreutils git python3 pandoc
```

`realpath` is in `AUR`

#### Docker installation

Install docker following the
[official guide](https://docs.docker.com/engine/installation/)

Do not forget to add your user to the docker group.

The command should be:

``` {.bash}
sudo usermod -a -G docker $USER
```

And you have to logout and login again to be effective.

### Download this repo

Move where you want to put WikiToLearnHome, for example your `$HOME`

``` {.bash}
cd $HOME
```

Then you can clone this repo with:

``` {.bash}
git clone --recursive https://github.com/WikiToLearn/WikiToLearnHome.git
```

This creates a folder called WikiToLearnHome.

Now you have to [GitHub personal token](https://github.com/blog/1509-personal-api-tokens) (leave all the *scopes* unchecked) (used for composer).

``` {.bash}
cd WikiToLearnHome
./create-config.sh -t <github token>
```

Now, if your github account is well configured and your PC is configured accordingly you can download the main WikiToLearn repo with:

``` {.bash}
./instance.sh download
```

### Initializing

This is the command to execute the first time (or if you delete all stuff):

``` {.bash}
./instance.sh first-run
```

Now you can work on your local instance of WikiToLearn and see your work
on [www.tuttorotto.biz](www.tuttorotto.biz)

### Usefull commands

You can shutdown the server with

``` {.bash}
./instance.sh stop
```

And start again with

``` {.bash}
./instance.sh start
```
