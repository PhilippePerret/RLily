# encoding: UTF-8
=begin

Méthodes qui s'occupent de la sortie en PDF ou en PNG

Noter que ce fichier a été isolé surtout parce que la commande lilypond est
différente suivant que l'on fait appel à RLily online (sur Icare)  ou en
local.

Si c'est pour uploader le fichier, mettre la constante ON_ICARE ci-dessous à true

=end

##
## METTRE À TRUE AVANT UPLOAD
##
ON_ICARE = false

class Score
  
  ##
  #
  # Sortie de la partition au format PDF
  #
  def output_as_pdf
    begin
      
      if ON_ICARE
        ##
        ## COMMANDE POUR UTILISATION DANS LES XEXTRA DE L'ATELIER ICARE
        ##
        cmd = "cd \"#{folder}\";/home/icare/bin/lilypond \"#{lilypond_filepath}\" 2>&1"        
      else
        ##
        ## COMMANDE POUR UTILISATION LOCALE DE L'APPLICATION
        ##
        cmd = "cd \"#{folder}\";echo \"#{App::su_password}\" | sudo -S lilypond \"#{lilypond_filepath}\" 2>&1"
      end
      
      dbg "Commande lilypond : #{cmd}", :notice
      `#{cmd}`
    rescue Exception => e
      dbg "Le construction du PDF a échoué.", :error
      return false
    end

    if File.exists?(pdf_filepath)
      dbg "\n\nLA PARTITION A ÉTÉ PRODUITE AVEC SUCCÈS\n#{pdf_filepath}", :notice
      # Ouverture du fichier PDF
      `open "#{pdf_filepath}"`
    else
      dbg "\n\nIMPOSSIBLE DE PRODUIRE LE PDF DE LA PARTITION…", :error
      dbg "Tape Pomme + R pour lancer la création de la partition à partir du fichier .ly produit."
      # Ouverture du fichier .ly pour le créer
      `mate "#{lilypond_filepath}"`
      return false
    end
    return true
  end
  
  ##
  #
  # Sortie de la partition au format PNG
  #
  def output_as_png
    begin
      
      if ON_ICARE
        ##
        ## COMMANDE POUR UTILISATION SUR L'ATELIER ICARE (XEXTRA)
        ##
        cmd = "cd \"#{folder}\";/home/icare/bin/lilypond -dbackend=eps -dno-gs-load-fonts -dinclude-eps-fonts -dpixmap-format=pngalpha"+
            (resolution ? " -dresolution=#{resolution}" : "") +
            " --png \"#{File.basename lilypond_filepath}\" 2>&1"
      else
        ##
        ## COMMANDE POUR UTILISATION LOCALE DE L'APPLICATION
        ##
        cmdllp = "lilypond -dbackend=eps -dno-gs-load-fonts -dinclude-eps-fonts -dpixmap-format=pngalpha --png \"#{lilypond_filepath}\""
        cmd = "cd \"#{folder}\";echo \"#{App::su_password}\" | sudo -S #{cmdllp} 2>&1"
      end


      dbg "Commande lilypond : #{cmd}", :notice
      `#{cmd}`
    rescue Exception => e
      dbg "Le construction du PNG a échoué.", :error
      return false
    end

    if File.exists?(png_filepath)
      dbg "\n\nLA PARTITION A ÉTÉ PRODUITE AVEC SUCCÈS EN IMAGE PNG\n#{png_filepath}", :notice
      # Ouverture du fichier PDF
      `open "#{png_filepath}"`
      return true
    else
      dbg "\n\nIMPOSSIBLE DE PRODUIRE L'IMAGE PNG DE LA PARTITION…", :error
      dbg "Tape Pomme + R pour lancer la création de la partition à partir du fichier .ly produit."
      # Ouverture du fichier .ly pour le créer
      `mate "#{lilypond_filepath}"`
      return false
    end
  end
  
end