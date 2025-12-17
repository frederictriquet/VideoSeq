# VideoSeq - Séquenceur Vidéo Musical

> 🎬 Un séquenceur innovant qui fonctionne comme un DAW audio mais avec des pistes vidéo

VideoSeq vous permet de créer des compositions musicales visuelles en synchronisant des vidéos courtes d'instruments. Chaque vidéo montre un son d'instrument et peut être déclenchée à différents instants pour créer une mélodie unique.

---

## ✨ Fonctionnalités

### 🎵 Séquenceur Professionnel

- **Timeline type DAW** - Interface inspirée des logiciels professionnels (Ableton, FL Studio)
- **Grille vidéo 3×3** - Affichage simultané de jusqu'à 9 vidéos d'instruments
- **Synchronisation audio/vidéo** - Lecture parfaitement synchronisée avec mixage audio
- **Contrôle BPM** - Ajustement du tempo de 40 à 300 BPM
- **Édition intuitive** - Glisser-déposer des clips sur la timeline

### 🎬 Gestion des Vidéos

- **Upload local** - Importez vos propres vidéos d'instruments
- **Assignation automatique** - Chaque instrument reçoit une région dans la grille
- **Lecture intelligente** - Les vidéos démarrent et s'arrêtent selon la timeline
- **Visualisation colorée** - Chaque instrument a sa propre couleur

### 🎛️ Contrôles

- **Transport** - Play, Pause, Stop
- **Navigation** - Cliquez sur la timeline pour vous déplacer
- **Tempo réglable** - BPM ajustable en temps réel
- **Boucle automatique** - La séquence boucle automatiquement

---

## 🚀 Démarrage rapide

### 1. Installation

```bash
# Cloner le projet
git clone <votre-repo>
cd VideoSeq

# Installer les dépendances
npm install
```

### 2. Lancer l'application

```bash
# Démarrer le serveur de développement
npm run dev

# L'application sera disponible sur http://localhost:5173
```

### 3. Utilisation

#### Ajouter un instrument

1. Entrez le nom de l'instrument dans le champ "Nom de l'instrument"
2. Cliquez sur "Ajouter Vidéo"
3. Sélectionnez un fichier vidéo court (quelques secondes)
4. L'instrument apparaît dans le panneau de gauche et occupe une région de la grille

#### Créer une séquence

1. Sur la timeline, cliquez sur une piste d'instrument où vous voulez placer un clip
2. Maintenez le bouton enfoncé et glissez pour définir la durée du clip
3. Relâchez pour créer le clip
4. Répétez pour ajouter d'autres clips

#### Éditer les clips

- **Déplacer** : Cliquez et glissez un clip sur la timeline
- **Supprimer** : Survolez un clip et cliquez sur le bouton ×

#### Contrôler la lecture

- **Play/Pause** : Cliquez sur le bouton play (triangle/pause)
- **Stop** : Arrête la lecture et revient au début
- **Naviguer** : Cliquez sur la timeline pour vous déplacer
- **Régler le BPM** : Modifiez la valeur dans le champ BPM

---

## 🎯 Conseils d'utilisation

### Format des vidéos recommandé

- **Durée** : 1-5 secondes par clip
- **Résolution** : 720p ou 1080p
- **Format** : MP4, WebM
- **Audio** : Incluez l'audio du son de l'instrument dans la vidéo

### Exemples de vidéos à créer

- Vidéos de vous-même jouant une note sur un instrument
- Captures d'écran de synthétiseurs virtuels
- Vidéos de samples visuels synchronisés avec des sons
- Animations générées avec du son

### Workflow créatif

1. Préparez 3-9 vidéos courtes d'instruments différents
2. Importez-les dans VideoSeq
3. Créez un pattern rythmique sur 4-8 beats
4. Ajustez le BPM pour trouver le bon groove
5. Expérimentez avec différents placements de clips

---

## 🛠️ Technologies

- **SvelteKit 5** - Framework web moderne et réactif
- **TypeScript** - Typage statique
- **Vite** - Build ultra-rapide
- **Canvas API** - Rendu de la timeline
- **Web Audio API** - Lecture vidéo synchronisée

---

## 📦 Scripts disponibles

### Développement

```bash
npm run dev              # Serveur de développement
npm run dev -- --open    # Ouvrir dans le navigateur
npm run preview          # Preview du build de production
```

### Build

```bash
npm run build            # Build de production
npm run check            # Type checking
```

### Tests

```bash
npm run test                      # Tests unitaires
npm run test:watch                # Tests unitaires en mode watch
npm run test:ui                   # Interface graphique pour les tests
npm run test:coverage             # Tests avec coverage
npm run test:e2e                  # Tests end-to-end
npm run test:e2e:ui               # Tests e2e avec interface
npm run test:mutation             # Tests de mutation (Stryker)
npm run test:mutation:incremental # Tests de mutation incrémentaux
npm run test:all                  # Tous les tests (sauf mutation)
```

### Docker

```bash
npm run docker:build     # Build l'image Docker
npm run docker:up        # Lance les conteneurs
npm run docker:down      # Arrête les conteneurs
npm run docker:logs      # Affiche les logs
npm run docker:restart   # Redémarre les conteneurs
```

---

## 📁 Structure du projet

```
.
├── .github/
│   ├── workflows/          # GitHub Actions CI/CD
│   │   ├── ci.yml          # Tests et qualité
│   │   ├── docker.yml      # Build et publication Docker
│   │   └── release.yml     # Versioning automatique
│   ├── COMMIT_CONVENTION.md
│   ├── SETUP_GITHUB.md     # Guide de configuration
│   └── TEMPLATE_SETUP.md   # Guide post-template
├── .husky/                 # Hooks Git
│   ├── commit-msg          # Validation des commits
│   └── pre-commit          # Checks pré-commit
├── src/
│   ├── lib/                # Composants et utilitaires
│   ├── routes/             # Pages SvelteKit
│   └── tests/              # Configuration des tests
├── tests/
│   └── e2e/                # Tests Playwright
├── Dockerfile              # Image Docker production
├── docker-compose.yml      # Orchestration Docker
├── vitest.config.ts        # Config tests unitaires
├── playwright.config.ts    # Config tests e2e
├── stryker.config.mjs      # Config tests mutation
├── commitlint.config.js    # Validation des commits
├── .prettierrc             # Formatage du code
└── package.json
```

Voir [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) pour plus de détails.

---

## 🔧 Configuration

### Variables d'environnement

Copiez `.env.example` vers `.env` et adaptez les valeurs :

```bash
cp .env.example .env
```

### Personnalisation

Après avoir créé un projet depuis ce template :

1. **package.json** : Changer `name`, `description`
2. **release-please-config.json** : Changer `package-name`
3. **README.md** : Adapter à votre projet
4. **docker-compose.yml** : Adapter les services si nécessaire

---

## 🤝 Convention des commits

Ce projet utilise [Conventional Commits](https://www.conventionalcommits.org/) pour le versioning automatique.

### Format

```
<type>(<scope>): <subject>
```

### Types

- `feat` : Nouvelle fonctionnalité (version mineure)
- `fix` : Correction de bug (version patch)
- `docs` : Documentation
- `style` : Formatage
- `refactor` : Refactoring
- `perf` : Performance
- `test` : Tests
- `build` : Build
- `ci` : CI/CD
- `chore` : Maintenance

### Exemples

```bash
git commit -m "feat: add user authentication"
git commit -m "fix: resolve navigation bug on mobile"
git commit -m "docs: update installation guide"
git commit -m "feat!: breaking change in API"
```

**Important :** Les hooks Husky valident automatiquement vos commits !

Voir [.github/COMMIT_CONVENTION.md](.github/COMMIT_CONVENTION.md) pour plus de détails.

---

## 🧪 Tests

### Tests unitaires (Vitest)

```bash
npm run test          # Exécution simple
npm run test:watch    # Mode watch
npm run test:ui       # Interface graphique
npm run test:coverage # Avec coverage
```

### Tests e2e (Playwright)

```bash
npm run test:e2e       # Exécution
npm run test:e2e:ui    # Interface graphique
npm run test:e2e:debug # Mode debug
```

### Tests de mutation (Stryker)

```bash
npm run test:mutation              # Complet
npm run test:mutation:incremental  # Incrémental (plus rapide)
```

Les rapports sont générés dans `reports/mutation/mutation.html`

---

## 🐳 Docker

### Build local

```bash
docker build -t mon-app .
docker run -p 3000:3000 mon-app
```

### Avec docker-compose

```bash
docker-compose up -d
```

### Image publiée automatiquement

Sur push vers `master`, l'image est automatiquement publiée sur :

```
ghcr.io/<votre-username>/sveltebase:latest
```

---

## 🚀 CI/CD

### Workflows automatiques

**CI (sur tous les pushs/PRs) :**

- Type checking
- Tests unitaires
- Tests e2e
- Build de production

**Docker (sur master uniquement) :**

- Build multi-plateforme
- Publication sur ghcr.io
- Tags automatiques (latest, SHA, version)

**Release Please (sur master uniquement) :**

- Analyse des commits
- Création de PR de release
- Versioning sémantique automatique
- Génération de CHANGELOG

Voir [.github/workflows/README.md](.github/workflows/README.md) pour plus de détails.

---

## 📚 Documentation

- [Guide de configuration GitHub](.github/SETUP_GITHUB.md)
- [Guide post-template](.github/TEMPLATE_SETUP.md)
- [Convention des commits](.github/COMMIT_CONVENTION.md)
- [Architecture du projet](docs/ARCHITECTURE.md)
- [Workflows CI/CD](.github/workflows/README.md)
- [Hooks Git](.husky/README.md)

---

## 🤝 Contribuer

Les contributions sont les bienvenues ! Consultez [CONTRIBUTING.md](CONTRIBUTING.md) pour les guidelines.

---

## 📝 Licence

MIT © [Frederic Triquet](https://github.com/frederictriquet)

---

## 🙏 Remerciements

Ce template est basé sur :

- [SvelteKit](https://kit.svelte.dev/)
- [Vitest](https://vitest.dev/)
- [Playwright](https://playwright.dev/)
- [Stryker](https://stryker-mutator.io/)
- [Release Please](https://github.com/googleapis/release-please)

---

## 📮 Support

- 🐛 [Issues](https://github.com/frederictriquet/SvelteBase/issues)
- 💬 [Discussions](https://github.com/frederictriquet/SvelteBase/discussions)
- 📧 Email: [votre-email]

---

**⭐ Si ce template vous est utile, n'hésitez pas à lui donner une étoile !**
