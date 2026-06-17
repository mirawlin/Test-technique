# Test Technique - Spring Boot REST API

## Contexte

Vous rejoignez une équipe qui développe une API REST de gestion d'utilisateurs. L'application Spring Boot existante expose un endpoint pour lister tous les utilisateurs, avec une base PostgreSQL lancée via Docker Compose.

Votre mission est d'ajouter une fonctionnalité, en respectant les bonnes pratiques de développement.

## Prérequis

- Java 21
- Maven
- Docker et Docker Compose
- Git

## Lancer l'application

```bash
docker-compose up --build
```

L'API sera disponible sur `http://localhost:8080`.

Endpoint existant :
```bash
curl http://localhost:8080/api/users
```

## Étapes du test

### 1. Créer une branche de travail

 Par exemple : `feature/get-user-by-id`


### 2. Écrire un test unitaire et implémenter un nouveau endpoint

On aimerait ajouter un nouveau fonctionalité pour retourner un utlisateur par son identifiant. 
Implémentez l'endpoint `GET /api/users/{id}` dans le contrôleur existant.
On doit egalement ajouter un test pour un nouvel endpoint `GET /api/users/{id}` qui retourne un utilisateur par son identifiant.

Un squelette de test est fourni dans `src/test/java/com/eval/testtech/controller/UserControllerTest.java` avec le mock et l'injection déjà configurés.

Le test doit :
- Utiliser **Mockito** pour mocker le `UserRepository`
- Vérifier le bon comportement du contrôleur (cas nominal et cas d'erreur)

Pour lancer les tests :
```bash
mvn test -Dtest=UserControllerTest
```

### 4. Réconcilier avec main

La branche `main` a été mise à jour pendant votre développement. Vous devez :
- Récupérer les changements de `main` (`git fetch`)
- Rebaser votre branche sur `main` (`git rebase origin/main`)
- Résoudre les éventuels conflits

### 5. Vérifier le fonctionnement

```bash
docker-compose up --build
curl http://localhost:8080/api/users/1
```

## Critères d'évaluation

- **Test unitaire** : bon usage de Mockito, couverture des cas nominaux et d'erreur
- **Code Spring** : respect des conventions, injection de dépendances, gestion des erreurs HTTP
- **Git** : bonne gestion de branche, rebase propre, résolution de conflits
- **Docker** : l'application se lance et fonctionne avec docker-compose
