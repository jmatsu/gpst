modules=[]

Dir.glob("#{File.expand_path('..', __FILE__)}/*.process.rb").each {|d|
  require d
  modules.push File.open(d).read[/module (.*)\n/, 1]
}

module Process
  module Inner
    
  end
end

modules.each {|m|
  Process::Inner.include Process.class.const_get(m)
}

Process.extend Process::Inner