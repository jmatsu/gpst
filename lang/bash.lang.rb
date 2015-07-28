module Bash
  class << self
    :private 
    
    def trim_debug line
      !line[/set\ -[eux]/i]
    end
  end

  def bash file_path
    Tempfile.open(File.basename(file_path)) {|tf|
      lines = File.readlines(file_path)
      lines.select! {|l|
        Bash.trim_debug l
      }
      tf.write lines.join("\n")
      tf.path
    }
  end
end