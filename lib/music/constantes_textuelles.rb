# encoding: UTF-8
=begin

Définition de constantes permettant d'écrire plus facilement.

Par exemple DOUBLE_BARRE pour "\bar \"||\" "

=end

# ---------------------------------------------------------------------
# NOTES 

A = "a"; B = "b"; C = "c"; D = "d"; E = "e"; F = "f"; G = "g"
def a; "a"; end
def b; "b"; end
def c; "c"; end
def d; "d"; end
def e; "e"; end
def f; "f"; end
def g; "g"; end

# ---------------------------------------------------------------------
#   CLÉS

CLE_G = CLE_SOL = "\\clef \"treble\" "
CLE_F = CLE_FA  = "\\clef \"bass\" "

# ---------------------------------------------------------------------
# JEU

PIQUE   = "."
LOURE   = "-"
ACCENT  = ">"

# ---------------------------------------------------------------------
# Liaisons

SLUR_UP   = "\n\\slurUp"
SLUR_DOWN = "\n\\slurDown"
REVERT_SLUR = "\n\\slurNeutral"


# ---------------------------------------------------------------------
# DIVERS

BREAK = "\n\\break\n"

# TAILLES DE SCORE (SCORE::taille)
PARTITION_CLASSIQUE = 20
LIVRET_POCHE        = 11
LIVRE_CHANT         = 18