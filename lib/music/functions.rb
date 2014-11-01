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

#---------------------------------------------------------------------
#   Méthodes de masquage/affichage
#---------------------------------------------------------------------

DATA_HIDE = {
  bar:    {mark: "Staff.BarLine", with_all: true},
  stem:   {mark: "Stem", with_all: true},
  rest:   {mark: "Rest", with_all: true},
  head:   {mark: "NoteHead", with_all: true},
  slur:   {mark: "Slur", with_all: true},
  beam:   {mark: "Beam", with_all: true}, 
  metrique: {mark: "Staff.TimeSignature", with_all: false},
  key: {mark: "Staff.Clef", with_all: false},
  staff: {mark_hide: "\\stopStaff", mark_show: "\\startStaff", with_all: true}
}
DATA_HIDE_FR2EN = {
  :barre => :bar, :hampe => :stem, :silence => :rest, :tete => :head,
  :liaison => :slur, :croche => :beam, :clef => :key, :cle => :key,
  :portee => :staff, :crochet => :beam
}

# Masque un élément
# La clé spéciale :all permet de tout masquer, sauf les valeurs spécifiées
# dans la propriété :except ({Array}) des +options+
def hide key, options = nil
  key = :all if key == :tous
  options = complete_hideshow_options options
  @hiddens          = key
  @options_hiddens  = options
  hidden_elements(key, options).collect do |key|
    raise "La clé hide #{key} est inconnue" if key.nil?
    get_hide_mark key
  end.join(' ').prepend(" ").concat(" ")
end
# Unmask un élément masqué
def show key = nil, options = nil
  key     ||= @hiddens
  options ||= @options_hiddens
  hidden_elements(key, options).collect do |k|
    raise "La clé show #{k} est inconnue" if k.nil?
    get_show_mark k
  end.join(' ').prepend(" ").concat(" ")
end

def hidden_elements key, options
  if key == :all
    DATA_HIDE.collect do |khide, dhide|
      next nil if dhide[:with_all] == false || options[:except].include?( khide )
      khide
    end.reject{ |e| e.nil? }
  elsif key.class == Array
    key
  else
    [key]
  end.collect do |k|
    if DATA_HIDE.has_key?( k )
      k
    else
      DATA_HIDE_FR2EN[ k ]
    end
  end
end
def get_hide_mark key
  data_key = DATA_HIDE[key]
  if data_key[:mark]
    "\\hide #{DATA_HIDE[key][:mark]}"
  else
    data_key[:mark_hide]
  end
end
def get_show_mark key
  data_key = DATA_HIDE[key]
  if data_key[:mark]
    "\\undo \\hide #{DATA_HIDE[key][:mark]}"
  else
    data_key[:mark_show]
  end
end

def complete_hideshow_options options
  options ||= {}
  options = options.merge(except: []) unless options.has_key? :except
  options
end

#---------------------------------------------------------------------
#   Méthodes textuelles
#---------------------------------------------------------------------

def write note, str, options = nil
  options ||= {}
  options = options.merge :up => true unless options.has_key?(:up)
  options = options.merge :strech => true unless options.has_key?(:strech)
  position = options[:up] ? "^" : "_"
  str = str.gsub(/\"/, '\"')

  code = ""
  code << "\\textLengthOn\n" unless options[:strech] == false
  code << "#{note}#{position}\"#{str}\""
  code << "\n\\textLengthOff\n" unless options[:strech] == false
  # "#{position}\\markup { \\line { #{str} } }"
  return code
end
alias :ecrire :write
alias :texte :write

def mark notes, str, options = nil
  options ||= {}
  place = if options[:left]
    "\n\\once \\override Score.RehearsalMark.self-alignment-X = #LEFT\n"+
    "\\mark \"#{str}\"\n" +
    notes
  elsif options[:right]
    notes
    "\n\\once \\override Score.RehearsalMark.self-alignment-X = #RIGHT\n"+
    "\\mark \"#{str}\"\n"
  else
    notes = notes.split(' ')
    nombre_notes = notes.count
    nb_moitie = (nombre_notes / 2) - 1
    nb_reste  = (nombre_notes - nb_moitie) + 2
    notes_avant = notes[0..nb_moitie].join(' ')
    notes_apres = notes[(nb_moitie+1)..(nombre_notes-1)].join(' ')
    
    "#{notes_avant} \\mark \"#{str}\" #{notes_apres}"
  end
end