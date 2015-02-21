# encoding: UTF-8
=begin

Module consacré exclusivement aux correction des textes spéciaux propres
à RLily qui sont transformés en code Lilypond.

=end
class Hand
  
  ##
  #
  # = main =
  #
  # Méthode principale qui corrige les notes et les renvoie pour
  # insertion dans le code du fichier Lilypond
  #
  # Certaines corrections ne peuvent se faire qu'avec le texte complet
  # D'autres part, les notes ({Array} pour le moment) sont rassemblées pour
  # composer un string
  #
  REG_REPRISE = /\|\:(.*?)\|1(.*?)\:\|2(.*?)\|\|/
  def correct_final_notes
=begin
\repeat volta 2 { c4 d e f | }
\alternative {
  { c2 e | }
  { f2 g | }
}
=end
    final = notes.join(" ")
    if final.index("|1")
      final.gsub!(REG_REPRISE){
        volta = $1
        alte1 = $2
        alte2 = $3
        "\\repeat volta 2 { #{volta.strip} } " +
        "\\alternative { { #{alte1.strip} }" + "{ #{alte2.strip} } }"
      }
    end
    # Double barre de reprise (ouverture)
    final = final.gsub(/ ?\:\|?\|\: ?/, ' DOUBLE_BARRE_REPRISE ').strip
    # Double barres
    final = final.gsub(/ ?\|\| ?/, ' \bar "||" ').strip  # double barre
    final = final.gsub(/ ?\|\: ?/, ' \bar ".|:" ').strip # barre de reprise (ouverture)
    final = final.gsub(/ ?\:\| ?/, ' \bar ":|." ').strip # barre de reprise (fermeture)
    
    final = final.gsub(/DOUBLE_BARRE_REPRISE/, ' \bar ":|.|:" ')
    
    return final
  end
 
  ##
  #
  # = sub main =
  #
  # Méthode principale qui est appelée lorsqu'un texte est
  # ajouté à une main. Par `MD << "<note>"' par exemple.
  #
  # Corrige les notes (p.e. les "#", "b", etc.)
  #
  def correct_notes str_notes
    Hand::Notes::new(str_notes).treate    
  end
  
  # ---------------------------------------------------------------------
  #
  #   Sous-classe Hand::Notes
  #   -----------------------
  #   Traitement des segments de notes envoyés par paquet, par exemple
  #   MD << "<paquet de notes>"
  #
  # ---------------------------------------------------------------------
  class Notes
    
    ##
    ## Les notes initiales envoyées
    ##
    attr_reader :notes_init
    
    ##
    ## Les notes en cours de traitement
    ##
    attr_reader :notes

    def initialize notes
      @notes_init = notes.to_s
      @notes      = notes.to_s
    end
    
    ##
    #
    # = main =
    #
    # Méthode principale traitant les notes de l'instance
    #
    def treate
      traite_alterations
      corrige_textes_speciaux
      return notes
    end
    
    ##
    #
    # Traite les altérations "#", "b", etc.
    #
    def traite_alterations
      @notes = notes.gsub(/([a-g])#/, '\1is')
        .gsub(/(\b[a-g])x/, '\1isis') # doubles-dièses
        .gsub(/^([a-g])(b+)/){ $1 + "es" * $2.length} # bémol(s) en première note
        .gsub(/([<\( ][a-g])(b+)/){ $1 + "es" * $2.length} # Les bémols
        .gsub(/ ?\|\|\. ?/, ' \bar "|." ').strip # barre de fin ||.
    end
    
    ##
    #
    # Traitement des textes spéciaux
    #
    # Par exemple les o{<texte>} qui doivement mettre le texte
    # dans un rond
    def corrige_textes_speciaux
      ##
      ## Textes dans un cercle, une boite
      ##
      @notes.gsub!(/([ob])\{(.*?)\}/){
        type  = $1
        texte = $2
        forme = case type
        when "o" then "circle"
        when "b" then "box"
        else "b" # box par défaut
        end
        "\\markup { \\#{forme} \\pad-around #0.5 { \"#{texte}\" } }"
      }
    end
  end
end