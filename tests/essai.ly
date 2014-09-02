
\paper{
  annotate-spacing = ##f
make-footer = ##f
system-separator-markup = \slashSeparator = ##f
}

%{
  Partition produite avec RLily et Lilypond
%}
\version "2.18.2"


\header {
  title = "Extension Hanon - Exercice 61"
  composer = "Phil Perret"
  opus = "Op. 17"
  
  instrument = "Piano"
}


\score{
  \new PianoStaff <<
  \new Staff {
  
  \clef treble
  \relative c' {
    \time 4/4
    \override Fingering.direction = #UP
    c d e
<c e g>
  }
}

  \new Staff {
  
  \clef bass
  \relative c {
    \time 4/4
    \override Fingering.direction = #DOWN
    c d e
<c e g>
  }
}

>>

  \layout{
  }
}
