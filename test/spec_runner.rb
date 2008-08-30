require 'rubygems'
require 'spec'
#require 'diff/lcs'
dir = File.dirname(__FILE__)
#require "#{dir}/../test/common_test_case"
require 'test/unit'
Test::Unit.run = true

args = ARGV.dup
unless args.include?("-f") || args.include?("--format")
  args << "--format"
  args << "specdoc"
end
#args << "--diff"
args << $0
$context_runner  = ::Spec::Runner::OptionParser.create_context_runner(args, false, STDERR, STDOUT)

def run_context_runner_if_necessary(system_exit, has_run)
  return if system_exit && !(system_exit.respond_to?(:success?) && system_exit.success?)
  return if has_run
  exit context_runner.run(true)
end

at_exit do
  has_run = !context_runner.instance_eval {@reporter}.instance_eval {@start_time}.nil?
  run_context_runner_if_necessary($!, has_run)
end
