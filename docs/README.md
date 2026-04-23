# AnimalTimer — Privacy Policy Site

Site statique hébergé sur **GitHub Pages** qui affiche la politique de
confidentialité d'AnimalTimer.

## URL publique

Une fois GitHub Pages activé sur ce dossier, l'URL est :

```
https://papadrien.github.io/AnimalTimer/
```

## Architecture

- `index.html` — Structure de la page + sélecteur de langue.
- `style.css` — Mise en forme sobre et responsive.
- `app.js` — Charge dynamiquement le contenu depuis les ARB du repo
  et rend les sections `policy*`.

## Source unique

Le contenu des règles de confidentialité n'est **pas dupliqué** dans ce
dossier. Il est lu à la volée par `app.js` depuis la branche `master` :

```
https://raw.githubusercontent.com/Papadrien/AnimalTimer/master/lib/l10n/app_fr.arb
https://raw.githubusercontent.com/Papadrien/AnimalTimer/master/lib/l10n/app_en.arb
```

Toute modification des clés `policy*` dans ces fichiers ARB sera
automatiquement reflétée sur le site au prochain chargement.

## Sections rendues

Les sections affichées, dans l'ordre :

1. `policyIntro` / `policyIntroContent`
2. `policyData` / `policyDataContent`
3. `policyAds` / `policyAdsContent`
4. `policyIAP` / `policyIAPContent`
5. `policyCOPPA` / `policyCOPPAContent`
6. `policyThirdParty` / `policyThirdPartyContent`
7. `policyGDPR` / `policyGDPRContent`
8. `policyContact` / `policyContactContent`

`policyUpdate` / `policyUpdateContent` apparaissent en pied de page.

## Langues supportées

- Français (`app_fr.arb`)
- Anglais (`app_en.arb`)

La langue est détectée automatiquement depuis le navigateur.
L'utilisateur peut la changer manuellement via les boutons en haut
de page.

## Maintenance

Pour modifier le texte de la politique de confidentialité :
1. Éditer les clés `policy*` dans `lib/l10n/app_fr.arb` et
   `lib/l10n/app_en.arb`.
2. Merger sur `master`.
3. Le site reflète les changements immédiatement.

Pour modifier le style ou la structure du site lui-même :
1. Éditer `index.html`, `style.css` ou `app.js`.
2. Merger sur `master`.
3. GitHub Pages redéploie automatiquement.

## Prérequis

- Le repo doit rester **public** pour que `raw.githubusercontent.com`
  serve les ARB sans authentification.
- GitHub Pages doit être activé sur la branche `master`, dossier `/docs`.
