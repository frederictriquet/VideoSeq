# SvelteBase

> 🚀 Template de projet SvelteKit complet avec CI/CD, tests, Docker et bonnes pratiques

Un template production-ready pour démarrer rapidement vos projets SvelteKit avec toutes les meilleures pratiques déjà configurées.

[![CI](https://github.com/frederictriquet/SvelteBase/actions/workflows/ci.yml/badge.svg)](https://github.com/frederictriquet/SvelteBase/actions/workflows/ci.yml)
[![Docker](https://github.com/frederictriquet/SvelteBase/actions/workflows/docker.yml/badge.svg)](https://github.com/frederictriquet/SvelteBase/actions/workflows/docker.yml)

---

## ✨ Fonctionnalités incluses

### 🎨 Frontend

- **SvelteKit 5** avec TypeScript
- **Vite** pour le build ultra-rapide
- **Adapter Node** pour production Docker
- Structure de projet optimisée

### 🧪 Tests

- **Vitest** - Tests unitaires avec UI
- **Playwright** - Tests e2e automatisés
- **Stryker** - Tests de mutation (mutation score: 100%)
- Coverage configuré avec V8

### ✅ Qualité de code

- **Husky** - Hooks Git automatiques
- **Commitlint** - Messages de commit conventionnels
- **Prettier** - Formatage automatique du code
- **lint-staged** - Vérifications pré-commit
- **svelte-check** - Validation TypeScript

### 🚀 CI/CD GitHub Actions

- **Workflow CI** - Tests, type checking, build
- **Docker Build & Push** - Publication automatique sur ghcr.io
- **Release Please** - Versioning sémantique automatique
- Caching optimisé (npm + Docker layers)

### 🐳 Docker

- Dockerfile multi-stage optimisé
- Build multi-plateforme (amd64 + arm64)
- docker-compose.yml pour développement
- Health checks configurés

### 📚 Documentation

- Guides de configuration complets
- Architecture documentée
- Conventions de code établies

---

## 🚀 Démarrage rapide

### 1. Utiliser ce template

Cliquez sur le bouton **"Use this template"** en haut de cette page, ou :

```bash
# Via GitHub CLI
gh repo create mon-projet --template frederictriquet/SvelteBase --private

# Ou clonez directement
git clone https://github.com/frederictriquet/SvelteBase.git mon-projet
cd mon-projet
```

### 2. Initialiser le projet

```bash
# Exécuter le script d'initialisation
./init-project.sh mon-projet "Description de mon projet"

# Ou manuellement :
npm install
npm run prepare  # Configure Husky
```

### 3. Développement

```bash
# Lancer le serveur de développement
npm run dev

# Ouvrir dans le navigateur
npm run dev -- --open
```

### 4. Configuration GitHub (Important !)

Suivez le guide : [.github/TEMPLATE_SETUP.md](.github/TEMPLATE_SETUP.md)

**Essentiel :** Activer les permissions GitHub Actions pour Release Please :

- Settings → Actions → General
- ✅ "Read and write permissions"
- ✅ "Allow GitHub Actions to create and approve pull requests"

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
