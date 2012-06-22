class User < ActiveRecord::Base
  default_scope order("key asc")
end
