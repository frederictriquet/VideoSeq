#!/bin/bash
# Script pour créer le package videoseq initial sur ghcr.io

set -e

echo "🐳 Push initial de l'image videoseq vers ghcr.io"
echo ""

# Build l'image localement
echo "📦 Build de l'image..."
docker build -t ghcr.io/frederictriquet/videoseq:initial .

echo ""
echo "🔐 Login à ghcr.io (utilisez un Personal Access Token avec scope write:packages)"
echo "Créez un token sur: https://github.com/settings/tokens"
echo ""

# Login (vous devrez entrer votre token)
docker login ghcr.io -u frederictriquet

echo ""
echo "📤 Push de l'image..."
docker push ghcr.io/frederictriquet/videoseq:initial

echo ""
echo "✅ Image pushée ! Le package videoseq est maintenant créé."
echo "Les futurs workflows GitHub Actions pourront maintenant y accéder."
