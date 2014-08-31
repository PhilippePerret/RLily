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
  attr_accessor :metrique
  attr_accessor :armure
  
  # Construction de la partition
  def build
    erase_old_files
    load_source
    compose
    save_lilypond_file
    
    # Production du PDF
    begin
      `echo "#{App::su_password}" | sudo -S lilypond "#{lilypond_filepath}"`
    rescue Exception => e
      puts "Le construction du PDF a échoué."
    end
    

    if File.exists?(pdf_filepath)
      puts "\n\nLA PARTITION A ÉTÉ PRODUITE AVEC SUCCÈS\n#{pdf_filepath}"
      # Ouverture du fichier PDF
      `open "#{pdf_filepath}"`
    else
      puts "\n\nIMPOSSIBLE DE PRODUIRE LE PDF DE LA PARTITION…"
      puts "Tape Pomme + R pour lancer la création de la partition à partir du fichier .ly produit."
      # Ouverture du fichier .ly pour le créer
      `mate "#{lilypond_filepath}"`
    end
  end
  
  
  # Chargement du code source
  def load_source
    load source
  end
  
  # Composition du code final
  def compose
    @code_final = []
    @code_final << lp_header
    @code_final << header
    @code_final << staves
    @code_final = @code_final.join("\n")
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
}

    HEADER
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