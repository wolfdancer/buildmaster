--------------------------------------------
Build Number System
--------------------------------------------

General
============================
Releasing of a product normally goes through several builds before the final release.  For each
release, the version number stays the same and the build number gets increased and the verseion
control system is tagged using something that is derived from the version number and build number.

In this way, your field testers can associate the bug with the product version number and build
numbers.

The implementation of the build number system varies depending on the kind of project.

Apach ANT BuildNumber Task
=============================
You can create a target in build file that uses [BuildNumber](http://ant.apache.org/manual/CoreTasks/buildnumber.html)
task, and use [Ant Driver](build-system.html).

Java Manifest
=============================
In Java project, the version number and build number are stored in the manifest file under `META-INF/MANIFEST`.
BuildMaster can read through it and increase the number.

<template:code source="build-number-samples.rb" tag="manifest" syntax="ruby"/>

Build Number File
=================================
Sometimes a file with just build number would suffice.  BuildMaster has a class that can just does that:

<template:code source="build-number-samples.rb" tag="buildnumber" syntax="ruby"/>
