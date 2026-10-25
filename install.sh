#!/bin/bash

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # Pas de couleur

echo -e "${YELLOW}=== Installation de Boxbox-Guard ===${NC}"

# 1. Vérification des droits root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}Erreur : L'installation doit être exécutée en root (sudo ./install.sh).${NC}"
   exit 1
fi

# 2. Vérification de la présence des fichiers sources
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ ! -f "$DIR/boxbox-guard" ]]; then
    echo -e "${RED}Erreur : Le fichier boxbox-guard est introuvable dans $DIR.${NC}"
    exit 1
fi


echo "[1/4] Mise en place de la configuration..."
# Copie des fichiers de configuration depuis le dossier 'etc' du git
mv "$DIR/etc/boxbox-guard/" /etc/
# Sécurisation des permissions
chmod -R 750 /etc/boxbox-guard/
# On cible uniquement les fichiers textes
chmod 640 /etc/boxbox-guard/*.conf /etc/boxbox-guard/*.csv /etc/boxbox-guard/*.info 2>/dev/null
chmod 644 /etc/boxbox-guard/boxbox-guard.service


echo "[2/4] Déploiement du moteur principal..."
mv "$DIR/boxbox-guard" /usr/local/bin/
chmod 700 /usr/local/bin/boxbox-guard


echo "[3/4] Configuration du service Systemd..."
# Création du lien symbolique (l'option -f écrase s'il existe déjà)
ln -sf /etc/boxbox-guard/boxbox-guard.service /etc/systemd/system/boxbox-guard.service

# Rechargement du démon systemd
systemctl daemon-reload


echo "[4/4] Démarrage du service..."
# Activation au démarrage et lancement immédiat
systemctl enable --now boxbox-guard

# Vérification du statut
if systemctl is-active --quiet boxbox-guard; then
    echo -e "${GREEN}Succès : Boxbox-Guard est installé et en cours d'exécution !${NC}"
else
    echo -e "${RED}Attention : Boxbox-Guard est installé mais semble avoir rencontré un problème au démarrage.${NC}"
    echo "Tapez 'systemctl status boxbox-guard' pour plus d'informations."
fi

# ==========================================
# Informations de fin pour l'utilisateur
# ==========================================
echo -e ""
echo -e "${CYAN}--- Résumé de l'installation ---${NC}"
echo -e "   ${YELLOW}Moteur principal${NC}   : /usr/local/bin/boxbox-guard"
echo -e "   ${YELLOW}Dossier principal${NC}  : /etc/boxbox-guard/"
echo -e "   ${YELLOW}Configuration${NC}      : /etc/boxbox-guard/boxbox-guard.conf"
echo -e "   ${GREEN}-> Par défaut, aucun test de sécurité n'est activé (valeurs à 0).${NC}"
#echo -e "   ${YELLOW}Liste d'exclusion${NC}  : /etc/boxbox-guard/containers-skip.csv"
echo -e "   ${YELLOW}Fichier de logs${NC}    : /var/log/boxbox-guard.log"
echo -e "   ${YELLOW}Dossier de cache${NC}    : /etc/boxbox-guard/.cache-error.d/"
echo -e ""
echo -e "Pour vérifier que le service tourne en arrière-plan :"
echo -e "   ${GREEN}systemctl status boxbox-guard${NC}"
echo -e ""


read -p "Appuyez sur [Entrée] pour terminer l'installation..."
