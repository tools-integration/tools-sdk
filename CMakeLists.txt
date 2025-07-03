cmake_minimum_required(VERSION 3.15)

project(tools-sdk
    LANGUAGES NONE
    DESCRIPTION "spack configs for the tools sdk"
    HOMEPAGE_URL tools-integration.github.io)

install(FILES spack/configs/packages.yaml DESTINATION spack/configs/toolssdk)
install(DIRECTORY spack/template DESTINATION spack/environments/toolssdk)
