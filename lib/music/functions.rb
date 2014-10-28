=begin

  Fonctions musicales pour simplifier le code

  `options' en deuxième argument des fonctions peut définir :
    :duree      La durée
    :doigte     Le doigté
    :jeu        L'indication du type de jeu, soit ".", "-" etc. soit les constantes
                textuels PIQUE, LOURE, ACCENT
=end

# Fonction générale permettant de traiter les "options" envoyées aux fonctions
# qui concernent tous les ajouts aux notes, durée, doigtés, etc.
def add_options str, options
  return str if options.nil?
  str += options[:duree].to_s if options.has_key?(:duree)
  after_tiret = []
  [:doigte, :jeu].each do |k|
    after_tiret << options[k].to_s if options.has_key?(k)
  end
  str += "-#{after_tiret.join('')}" unless after_tiret.empty?
  str = "\\relative c#{mark_octave options[:octave]}{ #{str} }" if options.has_key?(:octave)
  str.strip + " "
end
def mark_octave oct
  # Rappel : L'octave du DO sous la portée de sol est 
  # 4 en notation anglosaxone et 3 en notation française
  if oct == 3
    ""
  elsif oct > 3
    "'" * (oct - 3)
  else
    "," * (3 - oct)
  end
end

def rel notes, oct = 4
  notes = notes.join(" ") if notes.class == Array
  "\n\\relative c#{mark_octave oct}{\n\t#{notes}\n\t} "
end

def chord notes, options = nil
  notes = notes.join(" ") if notes.class == Array
  notes = "<#{notes}>"
  add_options notes, options
end

def triolet notes, options = nil
  notes = notes.split(' ') if notes.class == String
  notes = notes.collect{|note| add_options note, options}.join(" ")
  " \\tuplet 3/2 { #{notes} }"
end

# Marquer +nombre_octaves au-dessus ou en dessous
def octave notes, nombre_octaves = 1
  "\\ottava ##{nombre_octaves}\n#{notes}"
end

DATA_HIDE = {
  bar:    "Staff.BarLine",  barre: "Staff.BarLine",
  stem:   "Stem",     hampe: "Stem",
  rest:   "Rest",     silence: "Rest"
}
# Masque un élément
def hide key
  " \\hide #{DATA_HIDE[key]} "
end
# Unmask un élément masqué
def show key
  " \\undo \\hide #{DATA_HIDE[key]} "
end
