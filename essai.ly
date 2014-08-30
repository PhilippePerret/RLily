%{
  Partition produite avec RLily et Lilypond
%}
\version "2.18.2"


\header {
  title = "Extension Hanon - Exercice 61"
  composer = "Phil Perret"
}


\new PianoStaff <<
  \new Staff {
  \clef treble
  \relative c' {
    \override Fingering.direction = #UP
    c16-1 (d-2 e-3 d-2 e-3 d-2 f-4 g-5)
  }
}

  \new Staff {
  \clef bass
  \relative c {
    \override Fingering.direction = #DOWN
    c16-1 (d-4 e-3 d-4 e-3 d-4 f-2 g-1)
  }
}

>>
