require 'rake'

desc "install the dot files into user's home directory"
task :install do
  replace_all = false
  Dir['*'].each do |file|
    next if %w[Rakefile README.md LICENSE].include? file
    target_name = %[bin login.sql].include?(file) ? file : ".#{file}"
    if File.exist?(File.join(ENV['HOME'], target_name))
      if replace_all
        replace_file(file, target_name)
      else
        print "overwrite ~/#{target_name}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file, target_name)
        when 'y'
          replace_file(file, target_name)
        when 'q'
          exit
        else
          puts "skipping ~/#{target_name}"
        end
      end
    else
      replace_file(file, target_name)
    end
  end
  system "gem install hirb -v 0.3.5"
  system "gem install awesome_print -v 1.0.1"
end

task :default => :install

def replace_file(file, target_name)
  system %Q{rm -rf "$HOME/#{target_name}"}
  puts "linking ~/#{target_name}"
  system %Q{ln -s "$PWD/#{file}" "$HOME/#{target_name}"}
end
