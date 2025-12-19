# Architecture du projet SvelteBase

Ce document décrit l'architecture et l'organisation du template SvelteBase.

---

## 📁 Structure des répertoires

```
SvelteBase/
├── .github/                    # Configuration GitHub
│   ├── workflows/              # GitHub Actions CI/CD
│   │   ├── ci.yml              # Tests et qualité du code
│   │   ├── docker.yml          # Build et publication Docker
│   │   └── release.yml         # Versioning automatique (Release Please)
│   ├── COMMIT_CONVENTION.md    # Guide des commits conventionnels
│   ├── SETUP_GITHUB.md         # Configuration GitHub Actions
│   └── TEMPLATE_SETUP.md       # Guide post-template
│
├── .husky/                     # Hooks Git (Husky)
│   ├── _/                      # Fichiers internes Husky
│   ├── commit-msg              # Validation des messages de commit
│   ├── pre-commit              # Checks avant commit
│   └── README.md               # Documentation des hooks
│
├── docs/                       # Documentation du projet
│   └── ARCHITECTURE.md         # Ce fichier
│
├── src/                        # Code source de l'application
│   ├── lib/                    # Bibliothèque réutilisable
│   │   ├── components/         # Composants Svelte
│   │   ├── utils.ts            # Fonctions utilitaires
│   │   ├── utils.test.ts       # Tests des utilitaires
│   │   └── index.ts            # Exports publics
│   │
│   ├── routes/                 # Routes SvelteKit (file-based routing)
│   │   ├── +layout.svelte      # Layout global
│   │   └── +page.svelte        # Page d'accueil
│   │
│   ├── tests/                  # Configuration des tests
│   │   └── setup.ts            # Setup Vitest
│   │
│   ├── app.d.ts                # Types TypeScript globaux
│   └── app.html                # Template HTML de base
│
├── tests/                      # Tests externes
│   └── e2e/                    # Tests Playwright end-to-end
│       ├── home.test.ts        # Tests de la page d'accueil
│       └── navigation.test.ts  # Tests de navigation
│
├── static/                     # Assets statiques (servis tels quels)
│   └── favicon.png             # Favicon
│
├── build/                      # Build de production (généré, non versionné)
│
├── .svelte-kit/                # Fichiers SvelteKit générés (non versionnés)
│
├── node_modules/               # Dépendances npm (non versionnées)
│
├── reports/                    # Rapports de tests (non versionnés)
│   └── mutation/               # Rapports Stryker
│
├── .stryker-tmp/               # Cache Stryker (non versionné)
│
├── coverage/                   # Rapports de coverage (non versionnés)
│
├── .dockerignore               # Fichiers ignorés par Docker
├── .env                        # Variables d'environnement (non versionné)
├── .env.example                # Template des variables d'environnement
├── .gitignore                  # Fichiers ignorés par Git
├── .prettierignore             # Fichiers ignorés par Prettier
├── .prettierrc                 # Configuration Prettier
├── .release-please-manifest.json # Manifest Release Please
│
├── commitlint.config.js        # Configuration Commitlint
├── docker-compose.yml          # Orchestration Docker
├── Dockerfile                  # Image Docker de production
├── init-project.sh             # Script d'initialisation
├── package.json                # Dépendances et scripts npm
├── package-lock.json           # Lock file npm
├── playwright.config.ts        # Configuration Playwright
├── release-please-config.json  # Configuration Release Please
├── stryker.config.mjs          # Configuration Stryker
├── svelte.config.js            # Configuration SvelteKit
├── tsconfig.json               # Configuration TypeScript
├── vite.config.ts              # Configuration Vite
├── vitest.config.ts            # Configuration Vitest
│
├── README.md                   # Documentation principale
├── TEMPLATE_CHECKLIST.md       # Checklist pour template
└── DOCKER.md                   # Documentation Docker (optionnel)
```

---

## 🏗️ Stack technique

### Frontend

- **SvelteKit 5** - Framework full-stack
- **Svelte 5** - Framework UI réactif
- **TypeScript** - Typage statique
- **Vite** - Build tool et dev server

### Tests

- **Vitest** - Tests unitaires et d'intégration
- **Playwright** - Tests end-to-end
- **Stryker Mutator** - Tests de mutation
- **@testing-library/svelte** - Utilities pour tester les composants

### Qualité de code

- **Husky** - Hooks Git
- **lint-staged** - Lint sur fichiers stagés
- **Prettier** - Formatage du code
- **Commitlint** - Validation des messages de commit
- **svelte-check** - Validation TypeScript pour Svelte

### CI/CD

- **GitHub Actions** - Automatisation
- **Release Please** - Versioning sémantique
- **Docker** - Containerisation

### Adapter

- **@sveltejs/adapter-node** - Adapter Node.js pour production

---

## 🔄 Flux de développement

### 1. Développement local

```
Développeur
    │
    ├─> Édite le code
    │
    ├─> git add .
    │
    ├─> git commit -m "feat: nouvelle feature"
    │       │
    │       └─> PRE-COMMIT HOOK (Husky)
    │           ├─> lint-staged
    │           │   ├─> svelte-check (type checking)
    │           │   └─> prettier (formatage)
    │           │
    │           └─> COMMIT-MSG HOOK
    │               └─> commitlint (validation format)
    │
    └─> git push origin feature-branch
```

### 2. CI/CD Pipeline

```
Push vers GitHub
    │
    ├─> WORKFLOW CI (sur toute branche)
    │   ├─> Setup Node.js + cache npm
    │   ├─> npm ci
    │   ├─> npm run check (type checking)
    │   ├─> npm run test (tests unitaires)
    │   ├─> npm run test:e2e (tests e2e)
    │   └─> npm run build
    │
    ├─> WORKFLOW DOCKER (sur master uniquement)
    │   ├─> Setup Docker Buildx
    │   ├─> Login ghcr.io
    │   ├─> Build
    │   ├─> Push vers ghcr.io
    │   └─> Attestation de provenance
    │
    └─> WORKFLOW RELEASE PLEASE (sur master uniquement)
        ├─> Analyse les commits conventionnels
        ├─> Calcule la version (semver)
        ├─> Crée/met à jour PR de release
        │
        └─> Si PR de release mergée:
            ├─> Crée un tag Git
            ├─> Crée une GitHub Release
            ├─> Met à jour CHANGELOG.md
            └─> Met à jour package.json + manifest
```

### 3. Release Process

```
Commits conventionnels sur master
    │
    ├─> feat: ... (bump version mineure)
    ├─> fix: ...  (bump version patch)
    └─> feat!: ... (bump version majeure)
    │
    ├─> Release Please analyse
    │   └─> Crée PR "chore(master): release x.y.z"
    │
    └─> Merge de la PR de release
        ├─> Tag Git: vx.y.z
        ├─> GitHub Release
        ├─> CHANGELOG.md généré
        └─> Docker image: ghcr.io/.../app:x.y.z
```

---

## 🧩 Composants principaux

### SvelteKit (Framework)

**Rôle :** Framework full-stack pour Svelte

**Responsabilités :**

- Routing file-based
- Server-Side Rendering (SSR)
- API routes
- Build optimisé
- Adapters pour déploiement

**Fichiers clés :**

- `svelte.config.js` - Configuration SvelteKit
- `src/routes/` - Définition des routes
- `src/lib/` - Code réutilisable

### Vitest (Tests unitaires)

**Rôle :** Framework de tests rapide et moderne

**Responsabilités :**

- Tests unitaires
- Tests de composants
- Code coverage
- Mocking

**Fichiers clés :**

- `vitest.config.ts` - Configuration
- `src/**/*.test.ts` - Tests
- `src/tests/setup.ts` - Setup global

### Playwright (Tests e2e)

**Rôle :** Tests end-to-end multi-navigateurs

**Responsabilités :**

- Tests d'intégration complets
- Tests cross-browser
- Screenshots et vidéos
- Mode debug

**Fichiers clés :**

- `playwright.config.ts` - Configuration
- `tests/e2e/**/*.test.ts` - Tests e2e

### Stryker (Tests de mutation)

**Rôle :** Vérification de la qualité des tests

**Responsabilités :**

- Mutation du code source
- Exécution des tests sur mutations
- Calcul du mutation score
- Identification des tests faibles

**Fichiers clés :**

- `stryker.config.mjs` - Configuration
- `reports/mutation/` - Rapports

### Husky (Hooks Git)

**Rôle :** Automatisation des checks avant commit

**Responsabilités :**

- Exécution de scripts sur hooks Git
- Validation pré-commit
- Validation des messages

**Fichiers clés :**

- `.husky/pre-commit` - Checks avant commit
- `.husky/commit-msg` - Validation du message

### Docker

**Rôle :** Containerisation de l'application

**Responsabilités :**

- Build reproductible
- Déploiement uniforme
- Isolation des dépendances

**Architecture multi-stage :**

```dockerfile
# Stage 1: Builder
FROM node:20-alpine AS builder
- Installe toutes les dépendances
- Build l'application
- Génère les assets optimisés

# Stage 2: Runner
FROM node:20-alpine AS runner
- Copie seulement le nécessaire
- Installe uniquement les deps de prod
- Expose le port 3000
- Lance l'application
```

---

## 🔐 Sécurité

### Bonnes pratiques implémentées

1. **Pas de secrets dans le code**
   - Utilisation de `.env`
   - `.env` dans `.gitignore`
   - `.env.example` pour la documentation

2. **Validation des inputs**
   - TypeScript pour le typage
   - svelte-check pour la validation
   - Tests pour la logique métier

3. **Docker sécurisé**
   - Image multi-stage (moins de surface d'attaque)
   - User non-root recommandé
   - Scan de vulnérabilités dans CI

4. **CI/CD sécurisé**
   - Permissions minimales
   - Secrets GitHub (jamais dans les logs)
   - Attestation de provenance Docker

5. **Hooks Git**
   - Validation automatique
   - Prévention des commits problématiques
   - Formatage cohérent

---

## 📊 Patterns et conventions

### File-based routing (SvelteKit)

```
src/routes/
├── +page.svelte              → /
├── about/
│   └── +page.svelte          → /about
├── blog/
│   ├── +page.svelte          → /blog
│   └── [slug]/
│       └── +page.svelte      → /blog/:slug
└── api/
    └── users/
        └── +server.ts        → /api/users (API endpoint)
```

### Naming conventions

- **Components** : `PascalCase.svelte` (ex: `Button.svelte`)
- **Utilities** : `camelCase.ts` (ex: `formatDate.ts`)
- **Tests** : `*.test.ts` ou `*.spec.ts`
- **Types** : `PascalCase` (ex: `User`, `ApiResponse`)
- **Constants** : `UPPER_SNAKE_CASE` (ex: `API_BASE_URL`)

### Commit conventions (Conventional Commits)

```
<type>(<scope>): <subject>

Types:
- feat: nouvelle fonctionnalité
- fix: correction de bug
- docs: documentation
- style: formatage
- refactor: refactoring
- perf: performance
- test: tests
- build: build
- ci: CI/CD
- chore: maintenance
```

---

## 🚀 Performance

### Optimisations implémentées

1. **Build optimisé**
   - Tree shaking (Vite)
   - Code splitting automatique
   - Minification
   - Compression gzip

2. **Cache**
   - Cache npm dans CI
   - Cache Docker layers
   - Cache Stryker incrémental

3. **Docker**
   - Image multi-stage (plus petite)
   - Layer caching
   - Dépendances de prod uniquement

4. **Tests**
   - Tests en parallèle
   - Mode watch pour le dev
   - Tests incrémentaux (Stryker)

---

## 🔧 Extension du template

### Ajouter une nouvelle feature

1. **Créer la route** : `src/routes/ma-feature/+page.svelte`
2. **Créer les composants** : `src/lib/components/MaFeature.svelte`
3. **Créer les utils** : `src/lib/maFeature.ts`
4. **Ajouter les tests** : `src/lib/maFeature.test.ts`
5. **Tests e2e** : `tests/e2e/ma-feature.test.ts`

### Ajouter une dépendance

```bash
npm install <package>              # Production
npm install --save-dev <package>   # Développement
```

### Ajouter un workflow GitHub Actions

1. Créer `.github/workflows/mon-workflow.yml`
2. Définir les triggers
3. Définir les jobs
4. Tester sur une branche

### Ajouter des variables d'environnement

1. Ajouter dans `.env.example`
2. Documenter dans README
3. Utiliser dans le code : `import.meta.env.VITE_MA_VAR`
4. Ajouter dans Docker si nécessaire

---

## 📚 Ressources

- [SvelteKit Docs](https://kit.svelte.dev/docs)
- [Svelte Tutorial](https://svelte.dev/tutorial)
- [Vitest Docs](https://vitest.dev/)
- [Playwright Docs](https://playwright.dev/)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)

---

**Dernière mise à jour :** Décembre 2025
