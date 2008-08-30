#!/usr/bin/ruby

#######################################################################
=begin
 runant.rb

    This script is a translation of the runant.pl written by Steve Loughran.
    It runs ant with/out arguments
    This script has been tested with ruby1.8.2-14/WinXP

 created:         2005-03-08
 author:          Shane Duan
=end 

# Debugging flag
$debug = true

# Assumptions:
#
# - the "java" executable/script is on the command path
# - ANT_HOME has been set
# - target platform uses ":" as classpath separator or a "C:" exists (windows)
# - target platform uses "/" as directory separator.

#######################################################################
require 'Ant'

if not AntDriver.new().launch(ARGV)
  raise 'AntDriver failed'
end

