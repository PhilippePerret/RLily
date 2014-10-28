
\paper{
  annotate-spacing = ##f
make-footer = ##f
top-margin = 0.8\in
bottom-margin = 0.8\in
  
  
  ragged-bottom = ##f
  ragged-bottom-last = ##f
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
  \new PianoStaff \with {
    \override StaffGrouper.staff-staff-spacing = #'(
      (basic-distance . 3)
      (padding . 3))
  }
  <<
  \new Staff {
  
  \clef treble
  \relative c' {
    \time 4/4
    \override Fingering.direction = #UP
    c8 d e  \hide Stem  f g  \undo \hide Stem  a b c <c e g>
  }
}

  \new Staff {
  
  \clef bass
  \relative c {
    \time 4/4
    \override Fingering.direction = #DOWN
    c2 d  \hide Staff.BarLine  | e f  \undo \hide Staff.BarLine  | g a <c e g>
  }
}

>>

  \layout{
  }
}
