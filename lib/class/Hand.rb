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
  def << note; notes << note end
  
  # Initialise la liste des notes ou autres marques
  def notes;  @notes ||= []   end
  # Ré-initialise la liste des notes
  def reset_notes
    @notes = []
  end
  
  # Construction de la staff de la main
  def build
    <<-STAFF
\\new Staff {
  \\clef #{clef}
  \\relative #{relative} {
    \\time #{SCORE::metrique || '4/4'}
    \\override Fingering.direction = #{fingering_direction}
    #{notes.join(' ')}
  }
}
    STAFF
  end
  
  # Écrit la main dans le fichier
  def write
    puts notes.inspect
  end  
end
