require 'net/ftp'
require 'pathname'

module BuildMaster
class FtpDriver
  def initialize(host, user, password)
    @host = host
    @user = user
    @password = password
    @text_extnames = ['.txt', '.html', '.rb', '.bat']
  end
  
  def register_text_extname(extname)
    @text_extname.push(extname)
  end
  
  def upload(dir, remote_path = nil)
    Net::FTP.open(@host) do |ftp|
      ftp.login(@user, @password)
      files = ftp.chdir(remote_path) if remote_path
      upload_children(ftp, dir)
    end
  end
  
  private
  def upload_children(ftp, dir)
    names = gather_names(ftp)
    dir.list.each do |entry|
      upload_entry(ftp, names, entry)
    end
  end
  
  def gather_names(ftp)
    names = []
    ftp.list {|line| names.push line.split.pop}
    names
  end
  
  def upload_entry(ftp, names, entry)
    if (entry.respond_to? 'mkdirs')
      upload_dir(ftp, names, entry)
    else
      upload_file(ftp, entry)
    end
  end
  
  def upload_dir(ftp, names, dir)
    ftp.mkdir(dir.name) unless names.include? dir.name
    ftp.chdir(dir.name)
    upload_children(ftp, dir)
    ftp.chdir('..')
  end
  
  def upload_file(ftp, file)
    if @text_extnames.include? file.extname
      puts "uploading #{file.path} in text mode"
      ftp.puttextfile(file.path)
    else
      puts "uploading #{file.path} in binary mode"
      ftp.putbinaryfile(file.path)
    end
  end
end
end