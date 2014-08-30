=begin

  === main ===

Pour le moment, ne traite que les partitions pour le piano

Pour produire une partition :
---------------------------

  1. Créer un fichier .rb contenant la définition de la partition
  2. Définir la valeur SCORE_PATH ci-dessous avec la path de ce fichier
  3. Runner ce fichier (Pomme + R)

=end

# Path au fichier source User contenant la définition de la partition
SCORE_PATH = "./tests/essai"


require_relative 'lib/required'
begin
  SCORE.source= SCORE_PATH
  SCORE.build
rescue Exception => e
  puts "ERREUR : #{e.message}"
  puts e.backtrace.join("\n")
end

