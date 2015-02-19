# encoding: UTF-8
class Score
  
  # Création d'une "nouvelle ligne", c'est-à-dire un nouveau système de portée
  # Syntaxe dans le script : SCORE::new_line
  #
  def new_line
    memorize_stave
    Hand::reset_all_hands 
  end
  
end