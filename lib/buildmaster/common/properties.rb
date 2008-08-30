module BuildMaster
module Common

class Properties
  def Properties::parse_io(io)
    hash = Hash.new
    io.each_line do |line|
      line.strip!
      if (line[0..0] != '#')
        parse_into_hash(hash, line)
      end
    end
    return hash
  end
  
  private
  def Properties::parse_into_hash(hash, line)
    index = line.index(':')
    if (index)
      property = line[0, index].strip
      value = line[index + 1, line.length - index - 1].strip
      hash[property] = value
    end
  end
end

end
end