%{
  Partition produite avec RLily et Lilypond
%}
\version "2.18.2"


\paper{
  make-footer=##f
}

\header {
  title = ""
  composer = ""
  
  
}


\score{
  \new PianoStaff <<
  \new Staff {
  
  \clef treble
  \relative c' {
    \time 4/4
    \override Fingering.direction = #UP
    
  }
}

  \new Staff {
  
  \clef bass
  \relative c {
    \time 4/4
    \override Fingering.direction = #DOWN
    
  }
}

>>

  \layout{
  }
}
