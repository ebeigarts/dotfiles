# Allow using these gems without adding them to bundler
$LOAD_PATH << "#{ENV['HOME']}/.gem/ruby/2.0.0/gems/hirb-0.7.0/lib"
$LOAD_PATH << "#{ENV['HOME']}/.gem/ruby/2.0.0/gems/awesome_print-1.1.0/lib"

begin
  require "awesome_print"
  AwesomePrint.pry!
rescue LoadError, NameError => e
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

load "#{ENV['HOME']}/.railsrc" if $0 == 'script/rails' || $0 == 'rails_console' || ($0 == 'pry' && ENV['RAILS_ENV'])
