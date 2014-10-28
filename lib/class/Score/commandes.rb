class Score
  
  CIRCLE_NOTE = <<-TXT
circle =
\\once \\override NoteHead.stencil = #(lambda (grob)
    (let* ((note (ly:note-head::print grob))
           (combo-stencil (ly:stencil-add
note
               (circle-stencil note 0.1 0.5))))
          (ly:make-stencil (ly:stencil-expr combo-stencil)
            (ly:stencil-extent note X)
            (ly:stencil-extent note Y))))
  TXT
  
end