#!/usr/bin/ruby
# encoding: UTF-8

=begin

  === main ===

Pour le moment, ne traite que les partitions pour le piano

Pour produire une partition : Lire le manuel.

=end

if ARGF
  SCORE_PATH = ARGF.path
else
  SCORE_PATH = nil
end

require_relative 'lib/required'

begin
  # raise "Pour tenter de voir la sortie"
  SCORE.source = SCORE_PATH
  SCORE.build
rescue Exception => e
  # dbg "ERREUR : #{e.message}", :error
  # dbg e.backtrace.join("\n"), :error
  # App::show_debug
  puts e.message
  puts e.backtrace.join("\n")
end
