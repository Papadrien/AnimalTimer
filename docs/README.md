# AnimalTimer — Privacy Policy Site

Site statique hébergé sur **Cloudflare Pages** qui affiche la politique de
confidentialité d'AnimalTimer.

## URL publique

L'URL Cloudflare Pages (type `https://<project>.pages.dev`) sera renseignée
ici une fois le projet créé sur [pages.cloudflare.com](https://pages.cloudflare.com).

## Architecture

- `index.html` — Page statique autonome. Contient les textes FR + EN inlinés
  directement dans une balise `<script type="application/json">` et un petit
  script vanilla qui :
  * détecte la langue du navigateur,
  * permet de basculer manuellement FR / EN,
  * mémorise le choix dans `localStorage`.
- `style.css` — Mise en forme sobre et responsive (inchangé).

**Aucun fetch externe** : le site fonctionne parfaitement même quand le repo
GitHub est en **privé**, puisqu'il ne dépend d'aucune ressource distante
(pas d'appel à `raw.githubusercontent.com` ni à une API GitHub).

## Source unique : les ARB Flutter

Le contenu des règles de confidentialité vit dans les fichiers ARB de l'app,
sur la branche `develop` :

```
lib/l10n/app_fr.arb
lib/l10n/app_en.arb
```

Les clés utilisées (`policy*`) sont copiées dans `docs/index.html` au moment
de la génération. À chaque mise à jour des ARB, il faut **régénérer**
`docs/index.html` pour que le site affiche la nouvelle version.

## Sections rendues

Dans l'ordre :

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
L'utilisateur peut la changer manuellement via les boutons en haut de page.

## Déploiement Cloudflare Pages

1. Créer un projet Cloudflare Pages connecté à ce repo GitHub.
2. Build settings :
   - Framework preset : **None**
   - Build command : *(vide)*
   - Output directory : `docs`
   - Root directory : `/`
3. Branche de production : `master` (ou `develop` selon le besoin).
4. Cloudflare déploie automatiquement à chaque push.

Le repo peut être **privé** : Cloudflare conserve l'autorisation accordée à
l'installation et continue de builder normalement.

## Maintenance

Pour modifier le texte de la politique de confidentialité :

1. Éditer les clés `policy*` dans `lib/l10n/app_fr.arb` et
   `lib/l10n/app_en.arb`.
2. Régénérer `docs/index.html` à partir des ARB (via le script de sync
   convenu entre l'utilisateur et l'assistant).
3. Committer et pousser — Cloudflare Pages redéploie automatiquement.

Pour modifier le style ou la structure du site :

1. Éditer `index.html` ou `style.css`.
2. Commit + push — Cloudflare redéploie.
