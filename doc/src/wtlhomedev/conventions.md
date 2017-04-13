Conventions
===========

### Global Environment Variables

Environment Variables that are used by more than one script must begin with

    WTL-*

### Calling other scripts

In this repo there are many script that call other scripts. This action can be
performed in multiple ways, here it is preferred to use

```{.bash}
./script.sh
```

so that `$0` always refers the current script and not the calling one.
In order to make the caller script exit with error in the case that the called
script returns error, at the beginning of each script we use `set -e`, that
closes bash in case of error.

### if-statements

Every test, especially in if statements, is performed with the operator
`[[ ... ]]`, in order not to have to worry about the limitations of `[ ... ]`.

### Style Conventions

#### Line Length

All the lines should be shorter then 80 characters.

#### Indentation

Indentation is performed through 4 spaces. Hence we use soft tab, not hard tab.

If you are using vim, you can achieve this adding

```
set expandtab
set shiftwidth=2
set softtabstop=2
```

to `~/.vimrc`

## References

### bash

The script are all written in bash. A good source of information about bash can
be found [here][tldp-guide]

### Docker Containers

WikiToLearn Infrastructure uses extensively docker containers. If you do not
know what they are, we suggest that you read the
[official documentation][docker-doc]

### Documentation

The documentation is written in Markdown. The main advantage is that Markdown
obliges you to have well fomratted documentation pages. Moreover, if you use
an editor like [atom][atom] you can view a live preview of the html file
generated, which is terribly fancy.
If you have no clue on what it is,
we suggest that you read the [Markdown creator's page][markdown-doc].
This doc may contain man-like parts, which are formatted according to
[ronn][ronn] specifications, which is a programm to convert markdown to man
pages.

[tldp-guide]: http://tldp.org/guides.html "The Linux documentaion Project"
[docker-doc]: https://docs.docker.com/ "Docker Documentation"
[markdown-doc]: https://daringfireball.net/projects/markdown/ "Markdown Creator's Page"
[ronn]: http://rtomayko.github.io/ronn/

[atom]: https://atom.io "Atom, by Github"
[meta]: https://meta.wikitolearn.org
