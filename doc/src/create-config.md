# create-config.sh

## Description

This script should be the first to be run after pulling the repo. It creates `$WTL_CONFIG_FILE`, which stores machine-dependent global variables.

This script checks that:

- git, docker, curl, rsync, python, dirname and realtpath are properly installed
- the docker daemon is properly running and the user has the permissions to manage it.
- docker engine version

Then it loads the global variables contained in `const.sh`. Then the arguments are parsed and the proper checks on the arguments are performed, `$WTL_CONFIG_FILE` is created, `load-libs.sh` is run to check that the config file creation has been successfull. Eventually self signed certificates are generated (this are necesasry for accessign WTL with https).

## Synopsis

```{.bash}
./create-config.sh [-t|--token <token>] [-p|--protocol <protocol>]
    [ [--existing-repo] [--force-new-config] [-e|--environment <environment>]
      [--domain <domain>] [--branch <branch>] [--backup-max-num <num>]
      [--no-auto-checkout] [--no-auto-composer] [--production] ]
```

## Use Cases

We give some examples, based on different situations we think this script may be used in. We would really like to hear from you in order to make this list as exhaustive as possible!

- clean system, normal setup of WTL through WTLH

```{.bash}
./create-config.sh -t <token> -p <protocol>
```

- clean system, light WTL environment (no OCG)

```{.bash}
./create-config.sh -t <token> -p <protocol> --environment base-no-ocg
```

- already existing WTL local environment, making the transition to WTLH.

```{.bash}
./create-config.sh -t <token> -p <protobol> --exixting-repo
```

## Options

Compulsory

- `-t|--token <token>`: The token is necessary to use github composer. You have to pass this parameter. It is personal and should be kept securely, since it can be used instead of your credentials on github. WTL needs you to give full authorizations to your token. You can learn more abou github token [here](https://git.io/vmNUX).

- `-p|--protocol <protocol>`: `<protocol>=ssh` or `<protocol>=https`. This parameter controls the way you interact with the git repo. A git repo can always be cloned/pulled with https, while to clone/pull with ssh requires having a github account (which is also necessary for the token). Pushing a repo requires having been granted a particulat permissions either using ssh and https.

Optional

- `--existing-repo`: This script fails if it finds that the WikiToLearn folders already exist, because it may be that the user runs this config script when it is not needed. If you run `create-config.sh` with this argument, you skip the folder existance check. This parameter is intended to be used in case you already have downloaded WTL repo and want to start managing it through WTLH. Be carefull that `instance.sh` will update/pull WTL repo, be carefull (we invite you to commit/stash your WTL repo before running `instance.sh`)!

- `--force-new-config`: This script, as described above, creates a config file, which contains machine-dependent global variables, according to the user needs. This script ends with an error if the config file has already been created, since it may imply that this script has been run by accident, or that the consequences of this script are not that clear to the end user. If you run `create-config.sh` with this argument, you force the creation of a new config file, and you assume the responsibility of what you are doing! This parameter isnotintended to be used by the general user, but it is quite handy for WTLH developers (i.e. for us, beloved sysadmins)!

- `-e|--environtment <env>`: This parameter is used to set the environment, from the list of available environments. According to the needs of the user, it is possible to set up a different characteristics, such as the absence of OCG. The available environtments will be discussed later.

- `--domain <domain>`: This parameter is used to set the domain to access the local instance. This value is set to `local.wikitolearn-test.org` by default.

- `--branch <branch>`: This parameter is used to set the WTL repo branch that you want to switch to. This value is set to `master` by default.

- `--backup-max-num <num>`: This parameter is used to set how many quick backups you want to keep. The backup system will be described lately. The generic user should not bother this argument, it is meant for production.

- `--no-auto-checkout`: `instance.sh` performs a git checkuot before pulling the repo. This is why we recommend to commit any relevant change before running `create-config.sh` and `instance.sh`.

- `--no-auto-composer`: don't run composer when wtlhome downloads the code

- `--production`: This parameter is used to set the production environment, the generic user should not bother this.
