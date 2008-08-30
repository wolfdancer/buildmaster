----------------------------------------
Build System
----------------------------------------

General
============================
Build system should remain as the core of your project release, so that you can choose the one that
really suites your need.

Your build system should:
* Compiles source code
* Runs all the tests
* Generates the artifacts
* (Optionally) Publish the artifacts

BuildMaster driver does nothing more than driving the build system and raise the error when build fails

Rake and Gem
==============================
Rake and Gem are native to Ruby so you can just invoke them as part of your
release script.

For example, the following script will automatically run all the tests specified in file `rakefile.rb` 

<template:code source="build-system-samples.rb" tag="rake" syntax="ruby"/>

Apache ANT
==============================
At the moment, BuildMaster supports Ant only.

<template:code source="build-system-samples.rb" tag="ant" syntax="ruby"/>
