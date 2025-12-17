#!/bin/bash

# Script d'initialisation pour nouveau projet depuis SvelteBase template
# Usage: ./init-project.sh <nom-projet> "<description>"

set -e

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour afficher un message coloré
print_message() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_success() {
    print_message "${GREEN}" "✓ $1"
}

print_info() {
    print_message "${BLUE}" "ℹ $1"
}

print_warning() {
    print_message "${YELLOW}" "⚠ $1"
}

print_error() {
    print_message "${RED}" "✗ $1"
}

print_header() {
    echo ""
    print_message "${BLUE}" "════════════════════════════════════════"
    print_message "${BLUE}" "  $1"
    print_message "${BLUE}" "════════════════════════════════════════"
    echo ""
}

# Vérifier les arguments
if [ -z "$1" ]; then
    print_error "Usage: ./init-project.sh <nom-projet> \"<description>\""
    print_info "Exemple: ./init-project.sh my-app \"My awesome SvelteKit app\""
    exit 1
fi

PROJECT_NAME="$1"
PROJECT_DESCRIPTION="${2:-A SvelteKit application}"
CURRENT_DIR=$(pwd)
CURRENT_NAME=$(basename "$CURRENT_DIR")

print_header "🚀 Initialisation du projet SvelteBase"

print_info "Nom du projet: ${PROJECT_NAME}"
print_info "Description: ${PROJECT_DESCRIPTION}"
echo ""

# Confirmation
read -p "Continuer ? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Initialisation annulée"
    exit 0
fi

echo ""
print_header "📝 Mise à jour des fichiers de configuration"

# 1. Mettre à jour package.json
print_info "Mise à jour de package.json..."
if [ -f "package.json" ]; then
    # Utiliser sed pour remplacer le nom
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/\"name\": \"sveltebase\"/\"name\": \"${PROJECT_NAME}\"/" package.json
        sed -i '' "s/\"description\": \"\"/\"description\": \"${PROJECT_DESCRIPTION}\"/" package.json
    else
        # Linux
        sed -i "s/\"name\": \"sveltebase\"/\"name\": \"${PROJECT_NAME}\"/" package.json
        sed -i "s/\"description\": \"\"/\"description\": \"${PROJECT_DESCRIPTION}\"/" package.json
    fi
    print_success "package.json mis à jour"
else
    print_warning "package.json non trouvé"
fi

# 2. Mettre à jour release-please-config.json
print_info "Mise à jour de release-please-config.json..."
if [ -f "release-please-config.json" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/\"package-name\": \"sveltebase\"/\"package-name\": \"${PROJECT_NAME}\"/" release-please-config.json
    else
        sed -i "s/\"package-name\": \"sveltebase\"/\"package-name\": \"${PROJECT_NAME}\"/" release-please-config.json
    fi
    print_success "release-please-config.json mis à jour"
else
    print_warning "release-please-config.json non trouvé"
fi

# 3. Mettre à jour docker-compose.yml
print_info "Mise à jour de docker-compose.yml..."
if [ -f "docker-compose.yml" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/container_name: sveltebase/container_name: ${PROJECT_NAME}/" docker-compose.yml
    else
        sed -i "s/container_name: sveltebase/container_name: ${PROJECT_NAME}/" docker-compose.yml
    fi
    print_success "docker-compose.yml mis à jour"
fi

# 4. Créer .env depuis .env.example si nécessaire
print_info "Vérification du fichier .env..."
if [ ! -f ".env" ] && [ -f ".env.example" ]; then
    cp .env.example .env
    print_success ".env créé depuis .env.example"
elif [ ! -f ".env" ]; then
    print_warning ".env n'existe pas, vous devrez le créer manuellement"
else
    print_success ".env existe déjà"
fi

echo ""
print_header "📦 Installation des dépendances"

# Vérifier si node_modules existe
if [ ! -d "node_modules" ]; then
    print_info "Installation des dépendances npm..."
    npm install
    print_success "Dépendances installées"
else
    print_info "node_modules existe déjà, réinstallation..."
    npm install
    print_success "Dépendances mises à jour"
fi

echo ""
print_header "🎨 Configuration de Git"

# Vérifier si on est dans un repo git
if [ -d ".git" ]; then
    print_info "Repository Git détecté"

    # Proposer de réinitialiser l'historique
    echo ""
    print_warning "Voulez-vous réinitialiser l'historique Git ?"
    print_info "(Cela supprimera tous les commits précédents)"
    read -p "Réinitialiser ? (y/N) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf .git
        git init
        git add .
        git commit -m "chore: initial setup from SvelteBase template"
        print_success "Historique Git réinitialisé"
    else
        print_info "Historique Git conservé"
    fi
else
    print_info "Initialisation d'un nouveau repository Git..."
    git init
    git add .
    git commit -m "chore: initial setup from SvelteBase template"
    print_success "Repository Git initialisé"
fi

echo ""
print_header "✅ Configuration terminée !"

echo ""
print_success "Projet '${PROJECT_NAME}' initialisé avec succès !"
echo ""

print_info "📋 Prochaines étapes :"
echo ""
echo "  1. Vérifier et éditer .env avec vos variables d'environnement"
echo "  2. Lancer le serveur de développement :"
echo "     ${GREEN}npm run dev${NC}"
echo ""
echo "  3. Créer un repository GitHub :"
echo "     ${GREEN}gh repo create ${PROJECT_NAME} --private --source=. --remote=origin --push${NC}"
echo ""
echo "  4. Configurer les permissions GitHub Actions :"
echo "     Voir: .github/TEMPLATE_SETUP.md"
echo ""
echo "  5. Faire votre premier commit :"
echo "     ${GREEN}git add .${NC}"
echo "     ${GREEN}git commit -m \"feat: initial project setup\"${NC}"
echo "     ${GREEN}git push origin master${NC}"
echo ""

print_info "📚 Documentation :"
echo "  - Guide de setup : .github/TEMPLATE_SETUP.md"
echo "  - Configuration GitHub : .github/SETUP_GITHUB.md"
echo "  - Architecture : docs/ARCHITECTURE.md"
echo "  - Workflows CI/CD : .github/workflows/README.md"
echo ""

print_success "Bon développement ! 🚀"
echo ""
