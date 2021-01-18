# rotation-3D

VHDL implementation of the 3D rotation graphical motor using the _CORDIC_ algorithm.

## Setup

You can install [GHDL](https://ghdl.readthedocs.io/en/latest/), [GTKWave](http://gtkwave.sourceforge.net/) and [VSG](https://github.com/jeremiah-c-leary/vhdl-style-guide) on your machine, or you can use the _Vagrantfile_ (you need [Vagrant](https://www.vagrantup.com/) installed) to run all this tools inside that _VM_.

## Run



## Visualize

It runs [GTKWave](http://gtkwave.sourceforge.net/) to show the simulation.

```bash
$ make view COMPONENT=COMPONENT_NAME
```

## Linter

It runs [VSG](https://github.com/jeremiah-c-leary/vhdl-style-guide) _python_ module utility to force a style.

```bash
$ make lint
```

## Clean

To remove output generated files

```bash
$ make clean
```
