#Note importante Icare (à propos de l'usage local et distant)

Actuellement, ce dossier est uploadé par CMD+ALT+CTRL+U sur l'atelier icare dans le dossiers des `xextra`. Elle sert à créer les images de partition pour le Cercle pianistique.

Mais il ne faut SURTOUT PAS uploader le fichier&nbsp;:

    /lib/class/Score.rb

… qui contient d'autres commande sur le site, alors que les commandes de ce fichier sont censées fonctionner en local.

Si par malheur j'oubliais ça, il suffit de commenter et décommenter les lignes qui sont indiquées dans la méthode `output_as_pdf` et la méthode `output_as_png`.

