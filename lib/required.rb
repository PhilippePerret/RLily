# encoding: UTF-8

# Dossier principal
FOLDER_RLILY = File.expand_path(File.dirname(File.dirname(__FILE__)))
FOLDER_LIB   = File.join(FOLDER_RLILY, 'lib')

Dir["#{FOLDER_LIB}/class/**/*.rb"].each{|m| require m}
Dir["#{FOLDER_LIB}/function/**/*.rb"].each{|m| require m}
Dir["#{FOLDER_LIB}/music/**/*.rb"].each{|m| require m}