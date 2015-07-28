module Bash
  class << self
    :private 
    
    def submit? line
      line[/set\ -[eux]/i].nil?
    end

    def filter file_path
      Tempfile.open(File.basename(file_path)) {|tf|
        lines = File.readlines(file_path)
        lines.select! {|l|
          Bash.submit? l
        }
        tf.write lines.join("\n")
        tf.path
      }
    end
  end
end