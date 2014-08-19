# http://linux.die.net/man/1/irb

IRB.conf[:PROMPT_MODE]  = :SIMPLE

# Check if RVM hasn't already loaded some history.
if Readline::HISTORY.size == 0
  histfile = File.expand_path(".irb-history", ENV["HOME"])

  if File.exists?(histfile)
    lines = IO.readlines(histfile).collect { |line| line.chomp }
    Readline::HISTORY.push("") if Readline::VERSION == "EditLine wrapper" # OS X native ruby?
    Readline::HISTORY.push(*lines)
  end
  Kernel::at_exit do
    maxhistsize = 100
    histfile = File::expand_path(".irb-history", ENV["HOME"])
    lines = Readline::HISTORY.to_a.reverse.uniq.reverse
    lines = lines[-maxhistsize, maxhistsize] if lines.compact.length > maxhistsize
    File::open(histfile, "w+") { |io| io.puts lines.join("\n") }
  end
end

# Remove duplicates in history
module Readline
  alias :old_readline :readline
  def readline(*args)
    line = old_readline(*args)
    # Check history for duplicates
    dups = []
    Readline::HISTORY.each_with_index do |l, i|
      dups << i if l == line
    end
    dups.reverse!
    dups.each do |i|
      # i += 1 if Readline::VERSION == "EditLine wrapper" # OS X native ruby?
      Readline::HISTORY.delete_at(i)
    end
    # File.open("#{ENV['HOME']}/.irb-history", 'ab') { |f| f << "#{line}\n" }
    line
  end
end

def history
  Readline::HISTORY.to_a
end

# Allow using these gems without adding them to bundler
$LOAD_PATH << "#{ENV['HOME']}/.gem/ruby/2.0.0/gems/hirb-0.7.0/lib"
$LOAD_PATH << "#{ENV['HOME']}/.gem/ruby/2.0.0/gems/awesome_print-1.1.0/lib"

begin
  require "awesome_print"
  AwesomePrint.irb!
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

load File.dirname(__FILE__) + '/.railsrc' if $0 == 'script/rails' || $0 == 'rails_console' || ($0 == 'irb' && ENV['RAILS_ENV'])
