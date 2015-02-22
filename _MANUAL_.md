#RLily (Ruby to Lilypond)

* [Introduction/Présentation](#introduction)
* [Écriture du code partition](#write_code_partition)
  * [Écriture des notes](#write_notes)
  * [Écrire des barres de mesure](#les_barres_de_mesure)
  * [Définition de l'octave](#define_octave)
  * [Définir la clé](#define_cle)
  * [Écrire un accord](#write_chord)
  * [Écrire un triolet](#write_triolet)
  * [Écrire un passage à l'octave (8v---)](#write_a_loctave)
* [Masquer des éléments de la partition](#masquer_element_score)
  * [Masquer les barres, les notes, les silences, etc.](#masquer_portee_note_barre_etc)
  * [Masquer tout l'entête de la partition (titre, etc.)](#masquer_tout_le_header)
* [Éléments graphiques](#graphic_elements)
  * [Écrire une marque](#ecrire_une_marque)
  * [Écrire un texte](#ecrire_un_texte)
  * [Entourer une note d'un cercle](#entourer_note)
* [Indication de l'opus](#mark_opus)
* [Sous-titre](#sous_titre)
* [Indication de l'armure](#armure)
* [Indication du tempo](#mark_tempo)
* [Indication de l'instrument](#mark_instrument)
* [Définir l'espace entre titre et premier système](#define_espace_avant_premier_systeme)
* [Définir l'espacement entre les systèmes](#define_systeme_spacing)
* [Définir l'espacement entre les portées (du piano)](#define_espace_entre_portees)
* [Définir la taille de la partition (notes/portées)](#define_score_size)
* [Définir le format de sortie](#define_output_format)
  * [Sortie comme image PNG](#sortie_comme_image_png)
  * [Définition la résolution de la sortie](#define_score_resolution)
* [Réglage des options](#set_options)
  * [Demander l'affichage des dimensions](#option_show_spacing)
  * [Ajouter un slash entre les systèmes](#option_slash_between_systemes)




<a name='introduction'></a>
#Introduction présentation

`RLily` permet de construire rapidement une partition à l'aide de Lilypond, en produisant un code façon ruby.

Dans TextMate, avec le Bundle RLily&nbsp;:

1. Écrire le code en ruby (dans un fichier .rlily)
0. Taper `CMD + MAJ + P`

Et la partition est produite.

Pour le moment, cette partition est très simple, elle est produite pour le piano (clé de sol et clé de Fa) et ne supporte que les ajouts de notes (et autres marques du code normal de Lilypond comme les doigtés, les liaisons, les accords, etc.)

##Quick référence pour la création

1. Créer le fichier RLily (`.rlily`) qui va contenir le code pour la partition (c'est le "fichier source")
0. Définir les données du score ([Données générales du score](#donnees_generales))
0. Définir le contenu de chaque main avec `MD << "<notes>"` et `MG << "<notes>"`
  
La suite dépend de l'utilisation ou non du Bundle `Phil:RLily`. S'il est présent :

4. Avec le fichier source activé, utiliser le menu `Produire la partition` (ou jouer le raccourci `CMD + MAJ + P`)

Si le bundle n'est pas présent&nbsp;:

4. Ouvrir le fichier `_rlily.rb`
0. Définir la valeur de `SCORE_PATH` en mettant le path du fichier source
0. Runner `_rlily.rb` pour produire la partition

###En cas d'échec

Dans certains dossiers, les permissions peuvent manquer. Dans ce cas, le programme ouvre le fichier `.ly` dans TextMate (donc le fichier Lilypond que RLily produit), et il suffit alors de taper `CMD + R` pour produire la partition (si le Bundle Lilypond est installé).

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


<a name='masquer_element_score'></a>
#Masquer des éléments de la partition

<a name='masquer_portee_note_barre_etc'></a>
##Masquer les barres, les notes, les silences, etc.


On peut utiliser la pseudo-commande `hide(<element>)` (cacher) pour masquer des éléments de la partition, barres de mesures, hampes, etc.
  
`<element>` peut être (voir plus bas toutes les valeurs possibles)&nbsp;:
  
    Tous                    :all          Tout est masqué
    Un Symbole              :beam
    Une liste de symboles   [:beam, :staff]

Quand `:all` est envoyé à `hide`, peut définir les éléments qui ne doivent pas être masqués à l'aide d'un second argument&nbsp;:

    hide( :all, { except: [<liste de symboles>] } )

Par exemple, pour masquer tout sauf les liaisons&nbsp;:

    hide( :all, { except: [:slur] } )

On utilise à l'inverse la pseudo-command `show(<element>)` pour que les éléments soient affichés à nouveau.

Par exemple&nbsp;:

    MD << "c8 d e"
    MD << hide(:stem)
    MD << "f g a" # Les stems ne seront pas affichés
    MD << show(:stem)
    MD << "b c e" # Les stemps sont remises

On peut bien sûr indiquer tout sur une même ligne&nbsp;:

    MD << "c8 d e #{hide(:stem)} f g a #{show(:stem)} b c e"

*Note&nbsp;: Si ce qui est à remontrer avec `show` est identique à ce qui a été masqué avec `hide`, on peut simplement utiliser `show` sans arguments&nbsp;:*

    MD << "c8 d e"
    MD << hide([:stem, :staff])
    MD << "f g a" # Les stems et la portée ne seront pas affichés
    MD << show
    MD << "b c e" # Les stemps et la portée ré-apparaissent


Éléments qu'on peut masquer&nbsp;:

        ÉLÉMENT                  CLÉ              EXEMPLE
    ----------------------------------------------------------------
    TOUS                    :all  / :tous
    Barres de mesure        :bar / :barre         hide(:bar)
    Hampes (Stems)          :stem / :hampe        hide(:stem)
    Silences (Rest)         :rest / :silence      hide(:rest)
    Tête de notes           :head / :tete         hide(:head)
    Liasons                 :slur / :liaison      hide(:slur)
    Crochets                :beam / :crochet      hide(:beam)
    Métrique                :metrique             hide(:metrique)
    Clé                     :clef / :key          hide(:clef)
    ----------------------------------------------------------------

<a name='masquer_tout_le_header'></a>
##Masquer tout l'entête de la partition (titre, etc.)

Pour les images (`Score::output_format = :png`), il peut être utile de supprimer tout entête, titre, opus, etc. si c'est juste un extrait de partition qu'on veut afficher.

On peut supprimer facilement tout entête en indiquant en haut du fichier RLily&nbsp;:

    Score::no_header = true


<a name='graphic_elements'></a>
#Éléments graphiques

<a name='ecrire_une_marque'></a>
##Écrire une marque

*Note&nbsp;: une “marque” est plus visible, plus grosse qu'un texte. Pour écrire un “texte”, cf. [Écrire un texte](#ecrire_un_texte).*

Utiliser la méthode `mark` pour placer une marque de répétition (pas de reprise, de répétition au sens de “répéter avec son groupe” par exemple).

    mark("<notes>", "<texte de la marque>"[, { options }] )

Par exemple&nbsp;:

    MD << mark("c1 c", "Reprendre ce passage")

Par défaut, la marque est placé **au centre de l'élément précédent et l'élément suivant.** Par exemple&nbsp;:

    MD << mark("c1 c", "entre les deux")

… placera le "entre les deux" centré au-dessus de la barre séparant les deux mesures.

On peut demander que l'alignement se fasse à gauche ou à droite à l'aide du second argument de la méthode&nbsp;:

    MD << mark("sur le premier", left: true)

    MD << mark("c4 c c c", "sur le deuxième", right: true)

<a name='ecrire_un_texte'></a>
##Écrire un texte

*Note&nbsp;: un “texte” est plus petit qu'une “Marque”. Pour écrire une marque (de répétition par exemple, cf. [Écrire une marque](#ecrire_une_marque)).*

On peut utiliser la méthode `write` (ou ses alias `ecrire` ou `texte`) pour écrire un texte au-dessus/en dessous d'une note. 

Le premier argument doit être la note, le deuxième argument doit être le texte et un troisième argument Hash peut définir les options.

    ecrire( "<note>", "<texte>", {<options>} )

Par exemple&nbsp;:

    MD << write( "c", 'c\'est un DO') + "d"
    # => Écrira "C'est un DO" sur la note DO
    
###Placer le texte en dessous

On utilise le second argument de l'appel à la méthode en définissant la clé `:up`. Si elle est fausse, le texte est marqué en dessous de la note.

Par exemple&nbsp;:

    MG << texte('c', 'en dessous', { up: false } )

###Ne pas étirer le texte

Par défaut, la note suivante sera placée à la fin du texte. Pour éviter ce comportement, on peut ajouter `:strech => false` (ou `strech: false`) dans les options.

Par exemple&nbsp;:

    MD << write("c", "Un texte qui couvrira les autres notes", {strech: false} )

*Noter que cette option ne s'applique qu'au texte visé. Les textes suivants seront à nouveau “étirant”.*

<a name='entourer_note'></a>
##Entourer une note d'un cercle

Il suffit de placer `\circle` devant, par exemple&nbsp;:

    MD << "c \\circle d e" # la note Ré sera entourée

    
<a name="mark_opus"></a>
##Indication de l'opus

    SCORE::opus = <opus>

Par exemple&nbsp;:

    SCORE::opus = 13

*Note&nbsp;: Ne pas mettre "Opus" ou "Op."*

<a name='sous_titre'></a>
##Sous-titre

Pour indiquer un sous-titre&nbsp;:

    SCORE::sous_titre = "<le sous-titre>"

<a name="armure"></a>
##Indication de l'armure

    SCORE::armure = <armure>
    
`<armure>` se désigne comme les accords&nbsp;: "A#" pour La dièse majeur, "Bbm" pour Si bémol mineur, etc.

<a name="mark_tempo"></a>
##Indication du tempo

###Tempo pour la valeur de la noire

    SCORE::tempo = <tempo|tempo name>

Par exemple :

    SCORE::tempo = 126
    
    SCORE::tempo = "Andante"

###Tempo pour une valeur autre que noire

    SCORE::tempo = {:duree => <durée>, :tempo => <tempo>, :name => <nom tempo>}

Par exemple, pour mettre la croche (8) à 60&nbsp;:

    SCORE::tempo = {:duree => 8, :tempo => 60, :name => "Allegro"}
    

<a name="mark_instrument"></a>
##Définir l'instrument

    SCORE::instrument = <instrument>

<a name="define_espace_avant_premier_systeme"></a>
##Définir l'espace entre titre et premier système

    SCORE::espace_titre_systemes = <valeur>
    
<a name="define_systeme_spacing"></a>
##Définir l'espacement entre les systèmes

    SCORE::espace_entre_systemes = <valeur>
    
<a name="define_espace_entre_portees"></a>
##Définir l'espace entre les portées

    SCORE::espace_entre_portees = <valeur> # défaut : 3 (ne pas mettre une valeur trop grande)
    
<a name="define_score_size"></a>
##Définir la taille de la partition

    SCORE::taille = <valeur>

Où `<valeur>` peut être&nbsp;:
  
    PARTITION_CLASSIQUE/20    Taille normale pour les partitions classiques
    LIVRET_POCHE/11           Les livrets de poche
    13, 14, 16
    LIVRE_CHANT / 18          Les livres de chant
    23 et 26

<a name="write_code_partition"></a>
#Écrire le code de la partition

##Concaténation

Pour éviter les erreurs en additionnant des strings, la class `String` a été modifiée&nbsp;:

    "a" + "b"   => "a b"
    "a" << "b"  => "a b"

Donc il est inutile de terminer ou de commencer les strings de notes par des espaces.

<a name="options_fonctions_music"></a>
##Options pour les fonctions musicales

Ces options sont le second argument de toutes les fonctions musicales. Elles peuvent définir&nbsp;:

    :duree        La durée de la note/des notes
    :octave       L'octave (note : en notation anglosaxone, donc le DO sous la portée
                  de Sol est un Do 4)
    :doigte       Le doigté à utiliser
    :jeu          Le mode de jeu, défini explicitement avec du code 
                  lilypond (".", "-", etc.) ou les constantes textuelles
                  

<a name='write_notes'></a>
##Écriture des notes

Les notes s'écrivent comme dans Lilypond, à l'aide de **lettres minuscules de `a` à `g`.**

Pour les altérations, on peut utiliser la notation lilypond&nbsp;:

    ais => la dièse
    aes => la bémol

… ou la notation avec `#` et `b`&nbsp;:

    a#  => la dièse
    ab  => la bémol
    bb  => si bémol

**Altérations doubles**. Les altérations double (double-dièse, double-bémol) se marquent de façon simple par&nbsp;:

    x  (double-dièse)       correspond à "isis" dans Lilypond
    bb (double-bémol)       correspond à "eses" dans Lilypond

<a name="les_barres_de_mesure"></a>
##Écrire les barres de mesure

L'écriture des barres de mesure dans RLily est très intuitive.

Pour une **double barre**, ils suffit d'écrire… une double-barre&nbsp;:

    c a || b c

Pour la **barre de fin**&nbsp;:

    c a f ||.


Pour une **reprise simple** :

    |: c d e f :|

Pour une **double reprise**&nbsp;:

    |: c d e f :|: f e d c :|

Pour une **reprise avec alternative**

    |: <notes> |1 <notes première fois> :|2 <notes deuxième fois> ||

Plusieurs choses sont à noter ici&nbsp;:

* Seules 2 alternatives sont possibles avec cette écriture. S'il doit y en avoir plus, utiliser le code normal de Lilipond&nbsp;:

      \repeat volta <x fois> {
        <notes>
      }
      \alternative {
        { <première fois }
        { <première alternative }
        { <deuxième alternative }
        ...
        { <dernière fois> }
      }
* La fin de la deuxième alternative doit <u>obligatoirement</u> être indiquée par une double barre (`||`). Mais cette double-barre ne sera pas "écrite". Pour avoir réellement une double-barre sur la partition, il faut donc la répéter&nbsp;:

      |: c |1 d :|2 e || ||
      
<a name="define_octave"></a>
##Définir l'octave

Si des variables sont employées pour simplifier le code et le rendre plus explicite, il est bon de définir l'octave précise des motifs pour qu'ils puissent être enchainés. On utilise pour ça la fonction `rel` (pour "relative")&nbsp;:

    rel(<notes>, <octave>)
    # La première des <notes> commencera toujours à l'octave <octave>

Par exemple&nbsp;:

    rel("c e g", 5)
    # => \relative c''{ c e g }

Note&nbsp;: Pour définir une écriture avec "8ve----", cf. [Écrire à l'octave](#write_a_loctave).
    
<a name="define_cle"></a>
##Définir la clé

    MD << <clé>
    
Par exemple&nbsp;:

    # Par constante (cf. ci-dessous)
    MD << CLE_FA

    # Explicitement
    MD << "\\clef \"bass\""
    
    
Constantes&nbsp;:

    CLE_F/CLE_FA      Clé de fa
    CLE_G/CLE_SOL     Clé de sol
    
    
<a name="write_chord"></a>
##Écrire un accord

    chord(<"notes"|[notes]>[, <options>])

Par exemple&nbsp;:

    MD << chord("c e g")
    # => "<c e g>"
    
    MD << chord([c, E, g], :duree => 8)
    # => "<c e g>8"
    # Noter que les notes peuvent être définies par des minuscules ou des majuscules
    
    MD << chord("c e g", {:duree => 4, :jeu => PIQUE})
    # => "<c e g>4-."

Pour les `<options>`, cf. [Options pour les fonctions musicales](#options_fonctions_music)

<a name="write_triolet"></a>
##Écrire un triolet

    triolet(<notes>[, <options>])

Par exemple&nbsp;:

    MD << triolet([c, d, e])
    # => "\tuplet 3/2 { c d e }"
    
    MD << triolet("c d e", :duree => 16)
    # => "\tuplet 3/2 { c16 d e }"

Pour les `<options>`, cf. [Options pour les fonctions musicales](#options_fonctions_music)


<a name="write_a_loctave"></a>
##Écrire à l'octave

    octave(<notes>[, <nombre d'octave (1 par défaut)>])

Par exemple&nbsp;:

    MD << octave("c'' e f g")
    # => Ecrit les notes une octave en dessous, avec la marque "8ve-----"
    
    MD << octave("c''' e f g", 2)
    # => Ecrit les notes une octave en dessous, avec la marque "15ma-----"
    


<a name='define_output_format'></a>
##Définir le format de sortie

Par défaut, le programme produit un PDF de la partition.

On peut définir de sortir une image PNG plutôt en utilisant&nbsp;:

    SCORE::output_format = :png
    

<a name='sortie_comme_image_png'></a>
##Sortie comme image PNG

Il est très simple de faire une sortie PNG d'un extrait de partition en définissant&nbsp;:

    # entete du fichier .rlily
    SCORE::output_format = :png

Si on veut seulement l'image des portées, sans titre, opus ou autre marque de compositeur, utiliser&nbsp;:

    # Entete du fichier .rlily
    SCORE::output_format  = :png
    SCORE::no_header      = true

RLily sort alors une simple image PNG des portées en réduisant les blancs autour au maximum.


<a name='define_score_resolution'></a>
###Définition la résolution de la sortie

Pour définir la résolution, utiliser&nbsp;:

    SCORE::resolution   =  <valeur>

<a name="set_options"></a>
##Réglage des options

<a name="option_show_spacing"></a>
###Demander l'affichage des dimensions

    SCORE::option :display_spacing => true
    
    ou
    
    SCORE::option :display_spacing, true

<a name="option_slash_between_systemes"></a>
###Ajouter un slash entre les systèmes

    SCORE::option :slash_between_systemes => true
