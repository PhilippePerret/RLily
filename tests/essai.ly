
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
    c4^\markup { \rotate #40 "-> LA Maj." }
    \textLengthOn c1 \mark "Au centre" c \once \override Score.RehearsalMark.self-alignment-X = #LEFT \mark "À gauche" c4 c c c c c c c \once \override Score.RehearsalMark.self-alignment-X = #RIGHT \mark "À droite" \textLengthOn c8^"Bonjour" \textLengthOff \textLengthOn c^"Au revoir" \textLengthOff c8^"Bonjour" c^"Au revoir" <c e g> \hide NoteHead c16 b a g \undo \hide NoteHead f e d c16
  }
}

  \new Staff {

  \clef bass
  \relative c {
    \time 4/4
    \override Fingering.direction = #DOWN
    c2 d \hide Staff.BarLine | e f \undo \hide Staff.BarLine | g a <c e g>
  }
}

>>

  \layout{
  }
}
