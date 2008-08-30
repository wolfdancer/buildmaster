module BuildMaster
  # MySQL server driver to manage the MySQL server
  class MySqlServer
    # Given a CottaDirectory to the mysql home directory, creates an instance
    def initialize(home)
      @home = home
    end
    
    # starts the MySQL server
    def start
      ['INT', 'TERM'].each { |signal|
           trap(signal){ stop}
      }
      run('--console')
    end

    def stop(username = 'root', password = nil)
      exe = RubyPlatform.locate_execution_file!(@home, 'bin/mysqladmin')
      password_option = ' '
      password_option = " -p #{password}" if password
      @home.cotta.start("#{exe} -u #{username}#{password_option} shutdown")
    end

    # runs mysqld with provided argument
    def run(*argv)
      exe = RubyPlatform.locate_execution_file!(@home, 'bin/mysqld')
      @home.cotta.start("#{exe} #{argv.join(' ')}")
    end
  end
end