=begin

Classe de l'application

=end
class App
  
  class << self
    
    def su_password
      @su_password ||= File.read(File.join(folder_data, 'secret', 'SU_PASSWORD'))
    end
    
    def folder_data
      @folder_data ||= File.join(FOLDER_LIB, 'data')
    end
    
  end
  
end