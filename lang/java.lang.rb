module Java
  class << self
    :private
    
    def submit? line
      line[/^package\ .*/i].nil? && line[/[\t ]*Log\..*/i].nil?
    end

    def filter file_path
      Tempfile.open(File.basename(file_path)) {|tf|
        lines = File.readlines(file_path)
        lines.select! {|l|
          Java.submit? l
        }
        tf.write lines.join("\n")
        tf.path
      }
    end
  end
end