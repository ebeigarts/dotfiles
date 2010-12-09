# http://linux.die.net/man/1/irb

load "/etc/irbrc"
load File.dirname(__FILE__) + '/.railsrc' if $0 == 'script/rails' || ($0 == 'irb' && ENV['RAILS_ENV'])

IRB.conf[:PROMPT_MODE]  = :SIMPLE

# Allow using these gems without adding them to bundler
$LOAD_PATH << "#{ENV['HOME']}/.gem/ruby/1.8/gems/hirb-0.3.5/lib"
$LOAD_PATH << "#{ENV['HOME']}/.gem/ruby/1.8/gems/awesome_print-0.3.1/lib"
$LOAD_PATH << "#{ENV['HOME']}/.gem/ruby/1.8/gems/wirble-0.1.3/lib"

# begin
#   require "wirble"
#   Wirble.init
#   Wirble.colorize
# rescue LoadError => e
#   $stderr.puts e.message
# end

begin
  require "ap"
  module Kernel
    def ap(object, options = {})
      puts object.ai(
        :indent => -2,
        :color => {
          :array      => :white,
          :bignum     => :green,
          :class      => :yellow,
          :date       => :green,
          :falseclass => :white,
          :fixnum     => :green,
          :float      => :green,
          :hash       => :white,
          :nilclass   => :white,
          :string     => :green,
          :symbol     => :cyan,
          :time       => :green,
          :trueclass  => :green
        }
      )
    end
  end
  IRB::Irb.class_eval do
    def output_value
      ap @context.last_value
    end
  end
rescue LoadError => e
  $stderr.puts e.message
end

begin
  require "hirb"
  extend Hirb::Console
  Hirb.enable :pager => false
  Hirb.enable :formatter => false
rescue LoadError => e
  $stderr.puts e.message
end
