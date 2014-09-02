=begin

Classe de l'application

=end
class App
  
  class << self
    
    def debug txt, type = :notice
      @debug ||= []
      @debug << {:message => txt, :type => type}
    end
    
    def show_debug
      return if @debug.nil? || @debug.empty?
      # puts formate_debug
      STDOUT.write formate_debug
      @debug = []
    end
    def formate_debug
      messages = @debug.collect{|h| "<div class='#{h[:type]}'>#{h[:message]}</div>"}.join("\n")
      <<-HTML
<style type="text/css">
.error {color:red;}
.notice{color:blue;}
.date {margin-bottom:2em;}
</style>
<h1>Débug partition de «&nbsp;#{SCORE::titre}&nbsp;»</h1>
<div class='date'>Date : #{Time.now}</div>
#{messages}      
      HTML
    end
    
    def su_password
      @su_password ||= File.read(File.join(folder_data, 'secret', 'SU_PASSWORD'))
    end
    
    def folder_data
      @folder_data ||= File.join(FOLDER_LIB, 'data')
    end
    
  end
  
end