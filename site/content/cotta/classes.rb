$:.unshift File.join(File.dirname(__FILE__), '..', '..', '..', 'lib')

#START cotta
require 'buildmaster/cotta'
#END cotta

#START in memory
require 'buildmaster/cotta/in_memory_system'
#END in memory

$:.shift