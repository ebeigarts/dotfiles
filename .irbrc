require 'rubygems'
require 'wirble'
Wirble.init
Wirble.colorize

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
  end
end
