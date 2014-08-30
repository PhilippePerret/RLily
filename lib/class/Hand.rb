=begin

Class commune aux deux mains

=end
class Hand
  
  # Ajoute quelque chose à la main
  def << note; notes << note end
  
  # Initialise la liste des notes ou autres marques
  def notes;  @notes ||= []   end
  
  # Construction de la staff de la main
  def build
    <<-STAFF
\\new Staff {
  \\clef #{clef}
  \\relative #{relative} {
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
