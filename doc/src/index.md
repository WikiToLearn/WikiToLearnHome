# WikiToLearn Home Documentation

WikiToLearnHome is an orchestrator for WikiToLearn.

This environment is based on [docker](https://www.docker.com/) and [bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) scripts.

**!!DISCLAIMER!! WikiToLearn does not accept any responsbility or liability if your computer is damaged in any way.**

## Introduction

This documentation describes both how to use WikiToLearnHome to setup a WikiToLearn environment and how WikiToLearnHome works.

## Getting started

[This](getting-started.md) is a getting started guide to use WikiToLearnHome to work on WikiToLearn.

If you are only interested only in use WikiToLearnHome to work on WikiToLearn is everything you have to read.

## Setup with virtual machine

If you are using Windows, OSX or any other non OS based on a kernel non compatible with our docker images you can use a virtual machine.

[Here](vm-setup.md) some guidelines to bring up a VM suitable for WikiToLearnHome

## create-config.sh

`create-config.sh` is the script to create the WikiToLearnHome config file.

[Here](create-config.md) to read more.

## WikiToLearn Development

* [Add or update mediawiki extensions](wtldev/add-or-update-mediawiki-extension.md)

## WikiToLearnHome Development

* [Conventions](wtlhomedev/conventions.md)
* [Constants](wtlhomedev/const-doc.md)
* [load-libs.sh](wtlhomedev/load-libs-doc.md)
* [Recurring code](wtlhomedev/recurring.md)
