---
title: "Convertir le calendrier UdeM au format iCal"
tags: ["UdeM"]
date: 2012-08-20 20:32:00 -0400
---


Amis de l’UdeM,

L’interface de visualisation de l’horaire des étudiants est vraiment à exploser de larmes

Voici une solution pour convertir le tout en .ics compatible avec Outlook, Gmail, iCal, etc.

1. Utiliser Chrome
2. Aller sur le guichet étudiant et [consulter votre horaire](https://jade.daa.umontreal.ca/guichets/etudiant/dossier/horaire/cgi/11/e=ad40700,p=ad40701?debuter=debuter&amp;pageRetour=dossier).
3. Rendu sur la page de l’horaire, ouvrir le menu développeur de Chrome: Ctrl-Shift-I Sur Mac, c’est Cmd-Alt-I.
4. Cliquer sur le dernier onglet qui s’appelle “Console”
5. Là où le curseur clignote, coller ceci:


{% highlight javascript linenos %}
// bookmarklet-dev.js
(function(d,s){
    var n,b=d.getElementsByTagName(s)[0];
    function l(u){
        n=d.createElement(s);
        n.src=u;
        b.parentNode.insertBefore(n,b);
    }
    l("//ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js");
    l("//gist.github.com/raw/3409527/converter.js");
})(document, "script");
{% endhighlight %}
[View Gist](https://gist.github.com/lavoiesl/3409527)

Tout devrait fonctionner automatiquement et télécharger un fichier qui s’appellera download.ics



Si ça ne fonctionne pas, dîtes-moi le !
