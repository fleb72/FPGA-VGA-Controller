VGA Controller on DE0-nano with Quartus Prime

## Photo du montage
![Photo du montage](/images/photo-montage.jpg?raw=true "Photo du montage")
Voir les détails du matériel utilisé et les branchements dans le dossier *images*.


## Animation d'un sprite
Un envahisseur de l'espace (*space invader*) est parachuté dans l'espace.

![Animation sprite](/videos/FPGAanimatedSprite.gif?raw=true "Animation sprite")

![sprite](/images/invaders_parachute.gif?raw=true "sprite")

## Description

![schema RTL](/images/rtl_view_sprite.png?raw=true "Analyse RTL")

- *pll_Clock* : signal d’horloge à 25,2 MHz (pour le format 640x480@60Hz).
- *vga_sync* : signaux de synchronisation horizontale et verticale.
- *rom1* : mémoire ROM (m9k) où est préchargée l’image du sprite (voir dossier *fichier mif*).
- *sprite_generator* : calculs de déplacement du sprite et génération des signaux RGB.

Le fichier *Quartus Archive*  du projet (*VGA-dvp-animatedSprite.qar*) peut être importé dans Quartus Prime (édition 20.1.1 *lite*).
