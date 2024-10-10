# TOOLS SDK
Available as either a Spack meta-package or Spack environment configuration, which builds a set of TOOLS SDK member
packages together in a way that enables optimal features for target environments as well as interoperable features
provided by other packages within the TOOLS SDK.

## Using the Environment Configuration

To quickly start with the TOOLS SDK Spack environment there is a template environment available in `spack/template/spack.yaml`.

To use this environment, the path to this TOOLS SDK repo containing the TOOLS SDK configuration files must be set in the environment
variable `TOOLS_SDK_ROOT`. The environment then handles including the TOOLS SDK configurations. Modifications to the package
specification may be made for specific deployments as needed in the environment file.

To activate the template environment, which does not change the install root from the default location.

```console
export TOOLS_SDK_ROOT=/path/to/this/repo
spack env activate $TOOLS_SDK_ROOT/spack/template
```

Then concretize and install the packages on the system.

```console
spack concretize
spack install
```
