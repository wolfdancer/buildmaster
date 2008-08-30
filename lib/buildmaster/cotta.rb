$:.unshift File.join(File.dirname(__FILE__))

require 'cotta/cotta'
require 'cotta/in_memory_system'
require 'cotta/file_not_found_error'

$:.shift