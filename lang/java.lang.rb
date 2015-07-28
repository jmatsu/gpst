module Java
  class << self
    :private
    
    def trim_package line
      !line[/^package\ .*/i]
    end
  end

  def java file_path
    Tempfile.open(File.basename(file_path)) {|tf|
      lines = File.readlines(file_path)
      lines.select! {|l|
        Java.trim_package l
      }
      tf.write lines.join("\n")
      tf.path
    }
  end
end