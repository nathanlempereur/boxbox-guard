# boxbox-Guard V1.2

![Version](https://img.shields.io/badge/version-1.0-blue.svg)
![Status](https://img.shields.io/badge/status-Libre-orange)
![PHP](https://img.shields.io/badge/BASH2-777BB4)
![LXC](https://img.shields.io/badge/LXC-compatible-success)

![LXC](https://img.shields.io/badge/Debian-success)
![LXC](https://img.shields.io/badge/Ubuntu-success)

Boxbox-Guard est un système léger et modulaire de sécurité et de monitoring pour les conteneurs LXC sous Debian. Il tourne en arrière-plan sur l'hôte et surveille l'activité des conteneurs pour détecter et bloquer les compromissions en temps réel.



## Fonctionnalités (Capteurs) :

* **Détection d'utilisateurs illégitimes** (`TEST_USER`) : Vérifie si un attaquant crée un compte caché avec un accès shell (bash).
* **Détection de Backdoor SSH** (`TEST_ROOT_SSH`) : Vérifie l'ajout de clés SSH ou de fichier de configurations non autorisées dans le répertoire `/root/.ssh/`.
* **Détection de processus malveillants** (`TEST_PROGRAM`) : Vérifie l'exécution de programmes suspects (mineurs de crypto, malwares) depuis le dossier `/tmp`.
* **Détection de dissimulation** (`TEST_AUTH_CLEAR`) : Verifie si le fichier `/var/log/auth.log` est vidé pour effacer des traces.



## Actions de remédiation :

En cas d'attaque détectée, Boxbox-Guard peut réagir de deux manières (configurable) :

* **Simple** : Déconnecte immédiatement les interfaces réseau du conteneur infecté pour l'isoler (Quarantaine).
* **Hard** : Éteint instantanément le conteneur (`lxc-stop`).



## Installation :

Prérequis : Un hôte sous Linux (testé sur Debian 12) avec LXC installé.


```bash

# 1. Cloner le dépôt

git clone https://github.com/nathanlempereur/boxbox-guard.git
cd boxbox-guard


# 2. Lancer l'installation (en root)

chmod +x install.sh
sudo ./install.sh

```



## ⚙️ Configuration :

Les fichiers de configuration se trouvent dans `/etc/boxbox-guard/` :

* `boxbox-guard.conf` : Activez/Désactivez les capteurs et choisissez le type de sanction (`simple` ou `hard`).
* `boxbox-guard.service` : Modifier directement le service, celui-ci tourne sous un lien symbolique dans `/etc/systemd/system`.



Pour modifier et appliquer les changements, redémarrez le service :

```bash

systemctl restart boxbox-guard.service

```



## Logs et Debug :

Les alertes et actions entreprises par le script sont enregistrées dans :

```bash

tail -f /var/log/boxbox-guard.log

```

---

## Compatibilité !!

L'utilisation de cet outil est optimisée pour :
- **OS** : Linux / Ubuntu.
- **Droits** : Accès Root ou sudo obligatoire.

---

## Contribution & Licence

Ce module est **open-source**. Vous pouvez le modifier et proposer des améliorations via des **Pull Requests**.

**Licence** : Ce projet est sous licence libre.
**Contact** : contact@nlempereur.ovh

---

### Contact
- Email : **contact@nlempereur.ovh**
- Site web : https://nlempereur.ovh/contact.php
- Portfolio : https://nlempereur;ovh

---
