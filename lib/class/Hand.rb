# encoding: UTF-8
=begin

Class commune aux deux mains

=end
class Hand
  
  class << self
    def reset_all_hands
      MD::reset_notes
      MG::reset_notes
      LH::reset_notes
      RH::reset_notes
    end
  end
  
  # Ajoute quelque chose à la main
  def << note; notes << correct_notes(note) end
  
 
  # Initialise la liste des notes ou autres marques
  def notes;  @notes ||= []   end
  # Ré-initialise la liste des notes
  def reset_notes
    @notes = []
  end
  
  # Construction de la staff de la main
  def build
    return "" if @notes.nil? || @notes.empty?
    <<-STAFF
\\new Staff {
  #{key_signature}
  \\clef #{clef}
  \\relative #{relative} {
    \\time #{SCORE::metrique || '4/4'}
    \\override Fingering.direction = #{fingering_direction}
    #{correct_final_notes}
  }
}
    STAFF
  end
  
  ARMURES = {
    "C"  => "",
    "C#" => "cis \\major", "C#m" => "cis \\minor",
    "Db" => "des \\major", "Dbm" => "des \\minor",
    "D" => "d \\major", "Dm" => "d \\minor",
    "D#" => "dis \\major", "D#m" => "dis \\minor",
    "Eb" => "ees \\major", "Ebm" => "ees \\minor",
    "E" => "e \\major", "Em" => "e \\minor",
    "F" => "f \\major", "Fm" => "f \\minor",
    "F#" => "fis \\major", "F#m" => "fis \\minor",
    "Gb" => "ges \\major", "Gbm" => "ges \\minor",
    "G" => "g \\major", "Gm" => "g \\minor",
    "G#" => "gis \\major", "G#m" => "gis \\minor",
    "Ab" => "aes \\major", "Abm" => "aes \\minor",
    "A" => "a \\major", "Am" => "a \\minor",
    "Bb" => "bes \\major", "Bbm" => "bes \\minor",
    "B" => "b \\major", "Bm" => "b \\minor"
  }
  def key_signature
    return "" if SCORE::armure.nil? || SCORE::armure == "C"
    if ARMURES.has_key?(SCORE::armure)
      SCORE::armure = ARMURES[SCORE::armure]
    end
    "\\key #{SCORE::armure}"
  end
  
  
end
