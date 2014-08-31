# RLily

Permet de construire rapidement une partition à l'aide de Lilypond.

1. Écrire le code en ruby (dans un fichier .rb)
0. Taper `CMD + ALT + CTRL + S`

Et la partition est produite.

Pour le moment, cette partition est très simple, elle est produite pour le piano (clé de sol et clé de Fa) et ne supporte que les ajouts de notes (et autres marques du code normal de Lilypond comme les doigtés, les liaisons, les accords, etc.)

##Quick référence pour la création

1. Créer le fichier ruby (.rb) qui va contenir le code pour la partition (c'est le "fichier source")
0. Définir les données du score ([Données générales du score](#donnees_generales))
0. Définir le contenu de chaque main avec `MD << "<notes>"` et `MG << "<notes>"`
  
La suite dépend de l'utilisation ou non du Bundle `Phil:RLily`. S'il est présent :

4. Avec le fichier source activé, utiliser le menu `Produire la partition` (ou jouer le raccourci `CMD + ALT + CTRL + S`)

Si le bundle n'est pas présent&nbsp;:

4. Ouvrir le fichier `_rlily.rb`
0. Définir la valeur de `SCORE_PATH` en mettant le path du fichier source
0. Runner `_rlily.rb` pour produire la partition

###En cas d'échec

Dans certains dossiers, les permissions peuvent manquer. Dans ce cas, le programme ouvre le fichier `.ly` dans TextMate, et il suffit alors de taper `Command + R` pour produire la partition.

<a name="donnees_generales"></a>
##Données générales du score

Définir dans le code du fichier source (toutes les valeurs peuvent être omises) :

    SCORE::titre = "LE TITRE DU MORCEAU"
    SCORE::compositeur = "LE COMPOSITEUR"
    SCORE::armmure = "L'ARMURE ('A', 'B', etc.)"
    SCORE::metrique = "4/4"


##Constantes utiles

Le fichier `lib/music/constantes_textuelles.rb` contient des constantes textuelles utiles, pour marquer des barres, etc.



##Utilisation de la commande `rlily`

On peut construire une partition à l'aide de :

    rlily "path/to/file_partition.rb"

Pour que ça fonctionne, il faut que la commande `rlily` ait été définie :

    $ cd /usr/bin
    $ sudo touch rlily
    [Entrer mot de passe]
    $ sudo chmod 0777 rlily

ci-dessous, vous devez remplacer `PATH/TO/RUBY2LILY/` par le path à votre dossier téléchargé de ruby2lily :

    $ sudo echo 'exec PATH/TO/RUBY2LILY/ruby2lily.rb "$@"' > rlily
    # $ sudo echo 'exec /Users/philippeperret/Programmation/Programmes/RLily/_rlily.rb "$@"' > rlily
    $ sudo chmod u+x rlily
