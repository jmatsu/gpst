require "tempfile"

modules=[]

Dir.glob("#{File.expand_path('..', __FILE__)}/*.lang.rb").each {|d|
  require d
  modules.push File.open(d).read[/^module (.*)\n/, 1]
}

module Lang
  module Inner
    
  end
end

modules.each {|m|
  Lang::Inner.include Lang.class.const_get(m)
}

Lang.extend Lang::Inner