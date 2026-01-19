# Docker Exam - IPSSI

**Objectif :** mettre en place, dans un seul conteneur Docker, un serveur web basé sur Debian Bullseye capable de faire fonctionner simultanément un service PHP, un service de base de données MariaDB gérée sous PHPMyAdmin, un service WordPress installé via l'interface web.

Les services sont gérés par **Supervisor**, et la configuration de la base de données est réalisée au démarrage du conteneur via des variables d'environnement.

----

**⚙️ Variables d'environnement**

Les variables sont définis dans un fichier *.env*
Vous trouverez le modèle on *env_template.txt* que vous aurez besoin de copier dans votre propre fichier *.env* sur votre machine. Affectez ensuite la valeur que vous souhaitez sur chaque variable.

**🛢️ Initialisation de la base de données**

Lors du lancement du conteneur :
1. MariaDB est démarée temporairement
2. La base de données est créée
3. Un utilisateur est créé avec les droits permettant d'intéragir avec la base de données
4. MariaDB est arrêtée
5. Supervisor prend le relais pour gérer les services

Cette logique est implémentée dans le script *init.sh*.

----

**🚀 Lancement du projet**

```bash
docker build -t <nom-du-conteneur-que-vous-souhaitez-donner> .
```

```bash
docker run -d --name <nom-du-conteneur-que-vous-avez-créé> --env-file .env -p 3000:3000 <nom-du-conteneur-que-vous-avez-créé>
```

----

**🌐 Accès aux services**

- http://localhost/ pour la page d'accueil
- http://localhost/ pour la page d'index PHP
- http://localhost/phpmyadmin/ pour gérer la base de données
- http://localhost/wordpress/ pour WordPress

----

**INFO**

Bonus non implementé