Dir["#{FOLDER_LIB}/class/Score/**/*.rb"].each{|m| require m}
class Score
  def paper_definition
    liste_options = OPTIONS.collect do |k, d|
      "#{d[:command]} = ###{d[:value] ? 't' : 'f'}"
    end
    OTHER_OPTIONS.each do |k, d|
      next if d[:value].nil?
      liste_options << "#{d[:command]} = #{d[:value]}"
    end
    papdef = <<-LP
\\paper{
  #{liste_options.join("\n")}
  #{mark_espace_titre_systemes}
  #{mark_espace_entre_systemes}
  ragged-bottom = #{ragged_bottom}
  ragged-bottom-last = #{ragged_bottom_last}
}
    LP
    papdef.gsub(/\t+/,'').gsub(/\n\n/, "\n")
  end
  
  def ragged_bottom
    @ragged_bottom ||= "##f"
  end
  def ragged_bottom_last
    @ragged_bottom_last ||= "##f"
  end
  def mark_espace_titre_systemes
    return "" if espace_titre_systemes.nil?
    "\n" + <<-LP
    markup-system-spacing = #'(
    	(basic-distance   . #{espace_titre_systemes}) 
      (minimum-distance . #{espace_titre_systemes})
    	(padding . 0)
    	(stretchability . 0)
    ) 
    LP
  end
  def mark_espace_entre_systemes
    return "" if espace_entre_systemes.nil?
    "\n" + <<-LP
    system-system-spacing = #'(
    	(basic-distance   . #{espace_entre_systemes})
      (minimum-distance . #{espace_entre_systemes})
    	(padding          . 0)
      (stretchability   . 0)
    ) 
    LP
  end
end