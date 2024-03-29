require 'data_mapper'


# Set up DB
DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, 'sqlite3://' + File.join( File.dirname(__FILE__), 'test.db' ))


# Require all Models
require_relative '../models/User'

#Finalize Models, update if needed
DataMapper.finalize
#DataMapper.auto_migrate!
DataMapper.auto_upgrade!

DataMapper::Model.raise_on_save_failure = true
