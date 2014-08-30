# RLily

Permet de construire rapidement une partition à l'aide de Lilypond.

Pour le moment, cette partition est très simple, elle est produite pour le piano (clé de sol et clé de Fa) et ne supporte que les ajouts de notes (et autres marques du code normal de Lilypond comme les doigtés, les liaisons, les accords, etc.)

##Quick référence pour la création

1. Créer le fichier ruby (.rb) qui va contenir le code pour la partition (c'est le "fichier source")
0. Définir les données du score ([Données générales du score](#donnees_generales))
0. Définir le contenu de chaque main avec `MD << "<notes>"` et `MG << "<notes>"`
0. Ouvrir le fichier `_rlily.rb`
0. Définir la valeur de `SCORE_PATH` en mettant le path du fichier source
0. Runner `_rlily.rb` pour produire la partition


<a name="donnees_generales"></a>
##Données générales du score

Définir dans le code du fichier source (toutes les valeurs peuvent être omises) :

    SCORE::titre = "LE TITRE DU MORCEAU"
    SCORE::compositeur = "LE COMPOSITEUR"
    SCORE::armmure = "L'ARMURE ('A', 'B', etc.)"
    SCORE::metrique = "4/4"
