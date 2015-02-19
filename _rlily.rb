#!/usr/bin/ruby
# encoding: UTF-8

=begin

  === main ===

Pour le moment, ne traite que les partitions pour le piano

Pour produire une partition : Lire le manuel.

=end

# Path au fichier source User contenant la définition de la partition
# Sauf si le script est appelé via la console ou l'application Platypus.
# TODO : ÇA NE FONCTIONNE PAS POUR LE MOMENT
unless defined?(ARGV) && ARGV[0] != nil

  # === PATH DU FICHIER SOURCE ===

  SCORE_PATH = "./tests/bad"
else
  SCORE_PATH = ARGV[0]
end

require_relative 'lib/required'

begin
  # raise "Pour tenter de voir la sortie"
  SCORE.source = SCORE_PATH
  SCORE.build
rescue Exception => e
  dbg "ERREUR : #{e.message}", :error
  dbg e.backtrace.join("\n"), :error
  App::show_debug
end

