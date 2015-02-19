# encoding: UTF-8
=begin

Classe Lilypond

=end
class Lilypond
  class << self
   
    # Version de Lilypond en string
    def version
      @version ||= File.read(path_version).strip
    end
    
    def path_version
      @path_version ||= File.join(App::folder_data, 'LILYPOND_VERSION.txt')
    end
  end
end