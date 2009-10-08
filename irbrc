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

def t(data, *fields)
  if fields.empty?
    table data
  else
    table data, :fields => fields
  end
end

def establish_connection(name=nil)
  ActiveRecord::Base.establish_connection(name)
end

def connection
  ActiveRecord::Base.connection
end

# >> sql "select * from addresses_v where rownum < 3"
# +------+-----------+-----------+-------------+-----------+
# | code | id        | name      | name_sorted | parent_id |
# +------+-----------+-----------+-------------+-----------+
# | 104  | 100003124 | Balvi     | Balvi       | 100015741 |
# | 104  | 100003060 | Ventspils | Ventspils   | 100000000 |
# +------+-----------+-----------+-------------+-----------+
# 2 rows in set
# => true
def sql(query)
  table connection.select_all(query)
end

# >> nls
# +-------------------------+------------------------------+
# | parameter               | value                        |
# +-------------------------+------------------------------+
# | NLS_LANGUAGE            | LATVIAN                      |
# | NLS_TERRITORY           | LATVIA                       |
# ...
# +-------------------------+------------------------------+
# 19 rows in set
# => true
def nls
  sql "select * from v$nls_parameters"
end

# >> ddl :feedbacks
# CREATE TABLE "FEEDBACKS"
# ...
# => true
def ddl(name, type = :table)
  type = type.to_s.upcase
  schema, name = name.to_s.upcase.split('.').reverse
  query = "SELECT DBMS_METADATA.GET_DDL('#{[type, name, schema].compact.join(%{', '})}') FROM DUAL"
  printf connection.select_value(query)
  true
end

# >> desc :xxcrm_feedbacks
# +----------------+----------------+----------+-------+-------+-------+---------+---------+
# | name           | sql_type       | type     | limit | scale | null  | primary | default |
# +----------------+----------------+----------+-------+-------+-------+---------+---------+
# | id             | NUMBER(38)     | integer  | 38    | 0     | false |         |         |
# | feedback_type  | VARCHAR2(16)   | string   | 16    |       | true  |         |         |
# ...
# +----------------+----------------+----------+-------+-------+-------+---------+---------+
# 10 rows in set
# => true
def desc(name)
  table connection.columns(name), {
    :fields => [ :name, :sql_type, :type, :limit, :scale, :null, :primary, :default ]
  }
  true
end

# >> explain "select * from feedbacks"
# EXPLAIN PLAN FOR select * from feedbacks
# Plan hash value: 4248182647
# 
# -------------------------------------------------------------------------------
# | Id  | Operation         | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
# -------------------------------------------------------------------------------
# |   0 | SELECT STATEMENT  |           |     8 |  6080 |     5   (0)| 00:00:01 |
# |   1 |  TABLE ACCESS FULL| FEEDBACKS |     8 |  6080 |     5   (0)| 00:00:01 |
# -------------------------------------------------------------------------------
# 
# Note
# -----
#    - dynamic sampling used for this statement
# => true
def explain(query)
  explain_query = "EXPLAIN PLAN FOR #{query}"
  display_query = "SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY)"
  connection.execute(explain_query)
  puts explain_query
  connection.select_values(display_query).each do |line|
    puts line
  end
  true
end
