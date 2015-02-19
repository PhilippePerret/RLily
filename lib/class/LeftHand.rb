# encoding: UTF-8
=begin

Classe pour la main gauche

=end
class LeftHand < Hand

  def relative
    @relative ||= "c"
  end
  def clef
    @clef ||= "bass"
  end
  def fingering_direction
    "#DOWN"
  end
end
LH = LeftHand::new
MG = LH