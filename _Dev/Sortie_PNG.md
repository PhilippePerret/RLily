#Pour produire un PNG plutôt qu'un PDF

    lilypond -dbackend=eps -dno-gs-load-fonts -dinclude-eps-fonts -dpixmap-format=pngalpha --png myfile.ly