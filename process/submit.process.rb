modules=[]

Dir.glob("#{File.expand_path('../submit', __FILE__)}/*.submit.rb").each {|d|
  require d
  modules.push File.open(d).read[/^module (.*)\n/, 1]
}

module Submit
  module Inner

  end

  class << self
    :private

    def process file_path, *args
      contest = args[0]
      selectee = args[1]

      module_proc = Submit.class.const_get(contest.type.capitalize)
      module_proc.send("submit", file_path, contest, selectee)
    end
  end
end

modules.each {|m|
  Submit::Inner.include Submit.class.const_get(m)
}

Submit.extend Submit::Inner