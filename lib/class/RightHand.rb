# encoding: UTF-8
=begin
Classe pour la main droite
class RightHand < Hand

=end
require_relative 'Hand'
class RightHand < Hand

  def relative
    @relative ||= "c'"
  end
  def clef
    @clef ||= "treble"
  end
  def fingering_direction
    "#UP"
  end

end
MD = RightHand::new
RH = MD
