# encoding: UTF-8
# Définition de la partition

SCORE::titre        = "Extension Hanon - Exercice 61"
SCORE::compositeur  = "Phil Perret"
SCORE::metrique     = "3/4"

# Motif de départ

MD << "#{REP_START} c8-1 (d16-2 e-3 f-4 e-3 d-2 e-3 d-2 f-4 g8-5)"
MG << "c8-5 (d16-4 e-3 f-2 e-3 d-4 e-3 d-4 f-2 g8-1)"

MD << "d e16 f g f e f e g a8"
MG << "d e16 f g f e f e g a8"

SCORE::new_line

# Transition de montée à descente
MD << "e' f16 g a g f g f a-1 b8-3"
MG << "\\clef treble e' f16 g a g f g f a-1 b8-3"

MD << "c8-5 ( b16-4 a-3 g-2 a-3 b-4 a-3 b-4 g-2 f8-1)"
MG << "c8-1 ( b16-2 a-3 g-4 a-3 b-2 a-3 b-2 g-4 f8-5)"

MD << "b-5 a16-4 g-3 f g a g a f e8"
MG << "b-1 a16-2 g-3 f g a g a f e8"

SCORE::new_line

# Fin de l'exercice

motif = "g'8 f16 e d e f e f d c8 |"
MD << motif
MG << motif

motif = "f e16 d c d e d e c b8 #{REP_END} c2. #{BARRE_FIN}"
MD << motif
MG << motif


