require 'rubygems'
require 'wirble'
require 'hirb'
require 'irb/completion'
require 'irb/ext/save-history'

ARGV.concat [ "--readline", "--prompt-mode", "simple" ]
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history" 

Wirble.init
Wirble.colorize
extend Hirb::Console

class Object
  # get all the methods for an object that aren't basic methods from Object
  def my_methods
    (methods - Object.instance_methods).sort
  end
end

# from http://themomorohoax.com/2009/03/27/irb-tip-load-files-faster
def ls
  %x{ls}.split("\n")
end

def cd(dir)
  Dir.chdir(dir)
  Dir.pwd
end

def pwd
  Dir.pwd
end

# alias p pp
# alias quit exit

def change_log(stream)
  ActiveRecord::Base.logger = Logger.new(stream)
  ActiveRecord::Base.clear_active_connections!
end
 
def show_log
  change_log(STDOUT)
end
 
def hide_log
  change_log(nil)
end

# Shortcuts / aliases

def l!() show_log end
def r!() reload! end

def i!()
  case ActionController::Base.session.first[:session_key].gsub(/^_(.*)_session$/, '\1').to_sym
  when :timeweb
    User.current = User.first
    User.current_org_id = User.current.select_current_responsibility.org_id
    User.current_payroll_id = User.current.employee.payroll_id
  end
end

def nls
  ActiveRecord::Base.connection.select_all("select * from v$nls_parameters").each { |h| puts "#{h['parameter']} => #{h['value']}"};
  nil
end

def t(data, *fields)
  table data, :fields => fields
end
