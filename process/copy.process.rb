module Copy
  class << self
    :private

    def process file_path, *args
      system("cat #{file_path}|pbcopy")
    end
  end
end