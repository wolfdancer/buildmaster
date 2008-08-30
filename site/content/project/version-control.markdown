----------------------------------------------
Version Control
----------------------------------------------
General
=========================
BuildMaster supports CVS and Subversion by loading the information and carrying out the commands. Since both
system stores repository information on the working directory, you can load both driver by passing in 
the path to the working directory, wich is normally where your release script is.

In Ruby, you can find out the path of the directory which the current script is by `File.dirname(__FILE__))`

CVS
========================
The following is a sample code with CVS.

<template:code source="version-control-samples.rb" tag="cvs" syntax="ruby"/>

Subversion
==========================
BuildMaster gives you a bit more help as a Subversion driver.  It assumes default layout of your subversion
repository, i.e., trunk, tags and branches folder under the root.  So when you create tag with Subverseion
driver, you only need to tell it the name of the tag.

<template:code source="version-control-samples.rb" tag="svn" syntax="ruby"/>
