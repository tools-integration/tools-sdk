# Configuring Frontier

The configuration for Frontier requires two variables be set.

The first is for the TOOLS SDK configurations root (`TOOLS_SDK_ROOT`), which is
the root of the configs in the TOOLS SDK repository.

ie.

```console
$ # To use the files directly from github
$ export TOOLS_SDK_ROOT=https://raw.githubusercontent.com/tools-integration/tools-sdk/refs/heads/main
$
$ # Or
$
$ # To use a local clone of the configs
$ export TOOLS_SDK_ROOT=$HOME/.spack/tools-sdk/
```

The second variable to set is the Frontier configs path. These configs are maintained in cunjunction with
the E4S team. ([Spack Facility Configs](https://github.com/E4S-Project/facility-external-spack-configs))

ie.

```console
$ # To use the files directly from github
$ export FACILITY_CONFIG_ROOT=https://raw.githubusercontent.com/E4S-Project/facility-external-spack-configs/refs/heads/main
$
$ # Or
$
$ # To use a local clone of the configs
$ export FACILITY_CONFIG_ROOT=$HOME/.spack/facility-configs/

```
