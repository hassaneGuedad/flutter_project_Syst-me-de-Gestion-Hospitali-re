# 🐳 Guide Docker - Système de Gestion Hospitalière

Ce guide explique comment lancer le projet complet avec Docker.

## 📋 Prérequis

- **Docker Desktop** installé et en cours d'exécution
- **Docker Compose** (inclus avec Docker Desktop)

Vérifiez l'installation :
```bash
docker --version
docker compose version
```

## 🚀 Lancement Rapide

### Option 1: Script Windows (Recommandé)

Double-cliquez sur `docker-start.bat` ou exécutez :
```bash
docker-start.bat
```

### Option 2: Ligne de commande

```bash
# Construire et lancer tous les services
docker compose up -d --build

# Voir les logs
docker compose logs -f

# Arrêter les services
docker compose down
```

## 🏗️ Architecture Docker

Le projet utilise 3 services Docker :

1. **PostgreSQL** (port 5432)
   - Base de données principale
   - Volume persistant pour les données

2. **Backend Spring Boot** (port 8080)
   - API REST
   - Connecté à PostgreSQL
   - Swagger UI disponible

3. **Frontend Flutter** (port 3000)
   - Application web Flutter
   - Servi par Nginx
   - Proxy vers le backend

## 📡 Accès aux Services

Une fois lancé, accédez aux services via :

- **Frontend Web** : http://localhost:3000
- **Backend API** : http://localhost:8080
- **Swagger UI** : http://localhost:8080/swagger-ui.html (si configuré)
- **H2 Console** : http://localhost:8080/h2-console (si H2 activé)
- **PostgreSQL** : localhost:5432

## 🔧 Commandes Utiles

### Voir les logs
```bash
# Tous les services
docker compose logs -f

# Un service spécifique
docker compose logs -f frontend
docker compose logs -f backend
docker compose logs -f postgres
```

### Redémarrer un service
```bash
docker compose restart frontend
docker compose restart backend
```

### Reconstruire les images
```bash
# Reconstruire toutes les images
docker compose build --no-cache

# Reconstruire un service spécifique
docker compose build --no-cache frontend
```

### Arrêter les services
```bash
# Arrêter (conserve les volumes)
docker compose stop

# Arrêter et supprimer les containers
docker compose down

# Arrêter et supprimer tout (containers + volumes)
docker compose down -v
```

### Vérifier l'état
```bash
docker compose ps
```

## 🐛 Dépannage

### Port déjà utilisé
Si un port est déjà utilisé, modifiez-le dans `docker-compose.yml` :
```yaml
ports:
  - "3001:80"  # Au lieu de 3000:80
```

### Erreur de build Flutter
Si le build Flutter échoue :
```bash
# Nettoyer et reconstruire
docker compose down
docker compose build --no-cache frontend
docker compose up -d
```

### Backend ne démarre pas
Vérifiez les logs :
```bash
docker compose logs backend
```

Assurez-vous que PostgreSQL est démarré avant le backend (dépendance automatique).

### Frontend ne peut pas communiquer avec le backend
Vérifiez que :
1. Le backend est accessible sur http://localhost:8080
2. La configuration CORS dans `WebConfig.java` autorise localhost:3000
3. Le proxy nginx est correctement configuré

## 📝 Variables d'Environnement

Les variables peuvent être modifiées dans `docker-compose.yml` :

### PostgreSQL
- `POSTGRES_DB`: hospital_db
- `POSTGRES_USER`: postgres
- `POSTGRES_PASSWORD`: postgres

### Backend
- `SPRING_DATASOURCE_URL`: jdbc:postgresql://postgres:5432/hospital_db
- `SPRING_DATASOURCE_USERNAME`: postgres
- `SPRING_DATASOURCE_PASSWORD`: postgres

## 🔄 Mise à Jour du Code

Après modification du code :

```bash
# Reconstruire et redémarrer
docker compose up -d --build

# Ou pour un service spécifique
docker compose build frontend
docker compose up -d frontend
```

## 📊 Volumes Docker

Les données PostgreSQL sont persistantes dans le volume `postgres-data`.

Pour supprimer toutes les données :
```bash
docker compose down -v
```

## 🧪 Tests

Pour tester l'API backend :
```bash
# Health check
curl http://localhost:8080/actuator/health

# Liste des patients
curl http://localhost:8080/api/patients

# Liste des services
curl http://localhost:8080/api/services
```

## 🚨 Arrêt Propre

Utilisez `docker-stop.bat` ou :
```bash
docker compose down
```

Cela arrêtera tous les services proprement.

---

**Note** : Au premier lancement, la construction des images peut prendre plusieurs minutes. Les lancements suivants seront plus rapides grâce au cache Docker.

