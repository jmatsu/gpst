module Copy
  class << self
    :private

    def process file_path
      system("cat #{file_path}|pbcopy")
    end
  end
end