# encoding: UTF-8
=begin

Class pour produire la partition

  SCORE est une constante instance de la classe

Code pour régler l'espacement entre les systèmes :

system-system-spacing = #'(
	(basic-distance   . #{system_spacing})
  (minimum-distance . #{system_spacing_min})
	(padding          . #{system_spacing_pad})
  (stretchability   . 10)
)
ragged-bottom = ##t % Si False (##f), les portées se répartissent sur la feuille
ragged-bottom-last = ##t
#  où #{system_spacing} doit être un nombre (p.e. 10)

Code pour régler la distance entre le titre et le premier système

markup-system-spacing = #'(
	(basic-distance   . 20)
  (minimum-distance . #{system_spacing_min})
	(padding . 0)
	(stretchability . 0)

)



=end
class Score

  # Le fichier source contenant le code user
  attr_reader :source

  # Le code lilypond final produit
  attr_reader :code_final

  # Les systèmes créés (en général un seul, double)
  attr_accessor :staves

  # Données à définir à l'aide de SCORE::<donnée>
  attr_accessor :verbose # defaut : nil

  attr_accessor :no_header
  attr_accessor :titre
  attr_accessor :sous_titre
  attr_accessor :compositeur
  attr_accessor :piece
  attr_accessor :instrument
  attr_accessor :opus
  attr_accessor :metrique
  attr_accessor :armure
  attr_accessor :tempo
  attr_accessor :resolution
  # format de sortie (défaut: :pdf, peut être : :pdf, :png)
  attr_accessor :output_format
  # Espaces
  attr_accessor :espace_titre_systemes  # entre le titre et le 1er système
  attr_accessor :espace_entre_systemes  # entre les systèmes


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

  # Options True ou False
  OPTIONS = {
    # Affiche les dimensions sur la partition
    :display_spacing  => {:command => "annotate-spacing", :value => false},
    # Affiche le pied de page
    :display_footer   => {:command => "make-footer", :value => false}
  }
  # Options à autres valeurs
  OTHER_OPTIONS = {
    :top_margin     => {:command => "top-margin", :value => "0.8\\in"},
    :bottom_margin  => {:command => "bottom-margin", :value => "0.8\\in"},
    # Slash ("//") entre les systèmes : \\slashSeparator
    :slash_between_systemes => {:command => "system-separator-markup", :value => nil}
  }

  # Retourne ou définit l'option +key+
  def option key, value = nil
    if key.class == Hash
      value = key.values.first
      key   = key.keys.first
    end
    if OPTIONS.has_key? key
      OPTIONS[key][:value] = valeur unless value === nil
      return OPTIONS[key][:value]
    elsif OTHER_OPTIONS.has_key? key
      OTHER_OPTIONS[key][:value] = valeur
      return OTHER_OPTIONS[key][:value]
    else
      raise "Clé #{key} inconnue des options du score"
    end
  end

  # Construction de la partition
  def build
    puts "---> erase_old_files" if verbose
    erase_old_files
    puts "---> load_source" if verbose
    load_source
    puts "---> compose" if verbose
    compose
    puts "---> save_lilypond_file" if verbose
    save_lilypond_file

    # Production du PDF ou du PNG
    res = case output_format
    when :pdf, nil
      puts "---> output_as_pdf" if verbose
      output_as_pdf
    when :png
      puts "---> output_as_png" if verbose
      output_as_png
    else
      puts "Format de sortie inconnu (#{output_format}). Je sors en pdf"  if verbose
      output_as_pdf
    end

    if res === false || verbose
      App::show_debug
    end
  end

  # Chargement du code source
  def load_source
    load source
  end

  # Composition du code final
  def compose
    # On demande d'abord de construire le code des portées pour pouvoir
    # détecter les commandes-raccourcis qu'il faudra ajouter, par exemple
    # la variable \circle
    bloc_score

    @code_final = []
    @code_final << definitions_preliminaires
    @code_final << paper_definition
    @code_final << lp_header
    @code_final << commandes_raccourcis
    @code_final << header
    @code_final << bloc_score
    @code_final = @code_final.join("\n")
  end

  def definitions_preliminaires
    mark_score_size
    mark_score_resolution
  end
  def bloc_score
    @bloc_score ||= begin
    <<-LP
\\score{
  #{staves}
  \\layout{
  }
}
    LP
    end
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
\\new PianoStaff \\with {
    \\override StaffGrouper.staff-staff-spacing = #'(
      (basic-distance . #{espace_entre_portees})
      (padding . #{espace_entre_portees}))
  }
  <<
  #{MD.build}
  #{MG.build}
>>
    LP
  end

  def espace_entre_portees
    @espace_entre_portees ||= 3
  end
  def espace_entre_portees= value
    @espace_entre_portees = value
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

  REQUIRED_COMMANDES_RACCOURCIS = {
    :circle_note => false
  }
  # Commandes raccourcies
  def commandes_raccourcis
    str = []
    if REQUIRED_COMMANDES_RACCOURCIS[:circle_note] || bloc_score.index("\\circle")
      str << Score::CIRCLE_NOTE
    end
    str.join("\n")
  end

  # Entête header du fichier lilypond
  def header
    <<-HEADER
\\header {
  title = "#{titre || ''}"
  #{mark_subtitle}
  composer = "#{compositeur || ''}"
  #{mark_opus}
  #{mark_piece}
  #{mark_instrument}
}

    HEADER
  end

  def mark_subtitle
    return "" if sous_titre.nil?
    "subtitle = \"#{sous_titre}\""
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
  def mark_score_resolution
    return "" if resolution.nil?
    "#(ly:set-option 'resolution #{resolution})"
  end
  # Supprime les fichiers .ly et .pdf précédents s'ils avaient été
  # créés
  def erase_old_files
    File.unlink lilypond_filepath if File.exists? lilypond_filepath
    File.unlink pdf_filepath if File.exists? pdf_filepath
    App::init_log
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
  def png_filepath
    @png_filepath ||= File.join(folder, "#{affixe}.png")
  end

  # Définition du fichier source
  def source= path
    path = "#{path}.rlily" unless path.end_with?(".rlily")
    raise "Fichier introuvable (#{path})" unless File.exists? path
    @source = path
  end





end
SCORE = Score::new
