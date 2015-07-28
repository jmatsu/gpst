module Arc
  class << self
    :private

    def submit file_path, contest, selectee
      exec("#{File.expand_path('../', __FILE__)}/atcoder.submit.sh " "\"#{contest.url}\" " "\"#{contest.type}\" " "\"#{selectee.name}\" " "\"#{file_path}\"" )
    end
  end
end