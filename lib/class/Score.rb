=begin

Class pour produire la partition

  SCORE est une constante instance de la classe
=end
class Score
  
  # Le fichier source contenant le code user
  attr_reader :source
  
  # Le code lilypond final produit
  attr_reader :code_final
  
  # Les systèmes créés (en général un seul)
  attr_accessor :staves
  
  # Données à définir à l'aide de SCORE::<donnée>
  attr_accessor :titre
  attr_accessor :compositeur
  attr_accessor :piece
  attr_accessor :instrument
  attr_accessor :opus
  attr_accessor :metrique
  attr_accessor :armure
  attr_accessor :tempo
  
  # Taille de la partition (20 pour normal)
  attr_accessor :taille
  
  # Distance de la marge top au titre
  attr_accessor :top_spacing
  
#   <<-LP
# top-markup-spacing = #'(
#   (padding . 1)
#   (basic-distance . 40)
#   (minimum-distance . 40)
#   (stretchability . 0) % pour empêcher l'étirement automatique
# )
#   LP
  
  OPTIONS = {
    # Affiche les dimensions sur la partition
    :display_spacing  => {:command => "annotate-spacing", :value => false},
    # Affiche le pied de page
    :display_footer   => {:command => "make-footer", :value => false},
    # Slash ("//") entre les systèmes
    :slash_between_systemes => {:command => "system-separator-markup = \\slashSeparator", :value => false}
  }
  
  # Retourne ou définit l'option +key+
  def option key, value = nil
    if key.class == Hash
      value = key.values.first
      key   = key.keys.first
    end
    raise "Clé #{key} inconnue des options du score" unless OPTIONS.has_key? key
    OPTIONS[key][:value] = valeur unless value === nil
    return OPTIONS[key][:value]
  end
  
  # Construction de la partition
  def build
    erase_old_files
    load_source
    compose
    save_lilypond_file
    
    # Production du PDF
    begin
      cmd = "cd \"#{folder}\";echo \"#{App::su_password}\" | sudo -S lilypond \"#{lilypond_filepath}\" 2>&1"
      dbg "Commande lilypond : #{cmd}", :notice
      `#{cmd}`
    rescue Exception => e
      dbg "Le construction du PDF a échoué.", :error
    end
    

    if File.exists?(pdf_filepath)
      dbg "\n\nLA PARTITION A ÉTÉ PRODUITE AVEC SUCCÈS\n#{pdf_filepath}", :notice
      # Ouverture du fichier PDF
      `open "#{pdf_filepath}"`
    else
      dbg "\n\nIMPOSSIBLE DE PRODUIRE LE PDF DE LA PARTITION…", :error
      dbg "Tape Pomme + R pour lancer la création de la partition à partir du fichier .ly produit."
      # Ouverture du fichier .ly pour le créer
      `mate "#{lilypond_filepath}"`
      App::show_debug
    end
        
  end
  
  
  # Chargement du code source
  def load_source
    load source
  end
  
  # Composition du code final
  def compose
    @code_final = []
    @code_final << definitions_preliminaires
    @code_final << paper_definition
    @code_final << lp_header
    @code_final << header
    @code_final << bloc_score
    @code_final = @code_final.join("\n")
  end
  
  def definitions_preliminaires
    mark_score_size
  end
  def paper_definition
    liste_options = OPTIONS.collect do |k, d|
      "#{d[:command]} = ###{d[:value] ? 't' : 'f'}"
    end.join("\n")    
    <<-LP
\\paper{
  #{liste_options}
}
    LP
  end
  def bloc_score
    <<-LP
\\score{
  #{staves}
  \\layout{
  }
}
    LP
  end
  
  # On sauve le fichier Lilypond produit
  def save_lilypond_file
    File.open(lilypond_filepath, 'wb'){|f| f.write @code_final}
  end
  
  # Construction des portées
  def staves
    # On met toujours le système courant en mémoire
    memorize_stave
    # On renvoie tous les systèmes
    @staves.join("\n\n")
  end
  
  # Mémorisation du système courant
  def memorize_stave
    @staves ||= []
    @staves << stave
  end
  
  # Retourne le code pour le système courant
  def stave
    <<-LP
\\new PianoStaff <<
  #{MD.build}
  #{MG.build}
>>
    LP
  end
  
  # Entête du fichier lilypond
  def lp_header
    <<-HEAD
%{
  Partition produite avec RLily et Lilypond
%}
\\version "#{Lilypond::version}"

    HEAD
  end
  
  # Entête header du fichier lilypond
  def header
    <<-HEADER
\\header {
  title = "#{titre || ''}"
  composer = "#{compositeur || ''}"
  #{mark_opus}
  #{mark_piece}
  #{mark_instrument}
}

    HEADER
  end
  
  def mark_opus;        mark_property 'opus', 'Op. '; end
  def mark_piece;       mark_property 'piece';        end
  def mark_instrument;  mark_property 'instrument';   end
  def mark_property prop, avant = ""
    val = self.instance_variable_get("@#{prop}")
    return "" if val.nil?
    "#{prop} = \"#{avant}#{val}\""
  end
  
  #
  def mark_score_size
    return "" if taille.nil?
    "#(set-global-staff-size #{taille})\n"
  end
  # Supprime les fichiers .ly et .pdf précédents s'ils avaient été
  # créés
  def erase_old_files
    File.unlink lilypond_filepath if File.exists? lilypond_filepath
    File.unlink pdf_filepath if File.exists? pdf_filepath
  end
  
  # ---------------------------------------------------------------------
  #   Pathes
  # ---------------------------------------------------------------------
  
  # Affixe des fichiers produit
  def affixe
    @affixe ||= File.basename(source, File.extname(source))
  end
  # Dossier du fichier source
  def folder
    @folder ||= File.dirname(source)
  end
  
  def lilypond_filepath
    @lilypond_filepath ||= File.join(folder, "#{affixe}.ly")
  end
  
  def pdf_filepath
    @pdf_filepath ||= File.join(folder, "#{affixe}.pdf")
  end
  
  # Définition du fichier source
  def source= path
    path = "#{path}.rb" unless path.end_with?(".rb")
    raise "Fichier introuvable (#{path})" unless File.exists? path
    @source = path
  end
  
  
  
  
  
end
SCORE = Score::new