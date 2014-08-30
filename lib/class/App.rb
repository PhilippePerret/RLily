=begin

Classe de l'application

=end
class App
  
  class << self
    
    def folder_data
      @folder_data ||= File.join(FOLDER_LIB, 'data')
    end
  end
  
end