# Guide Examinateur

## Setup initial

1. Créer un repository Git distant (GitHub, GitLab, etc.)
2. Pousser le code initial :
   ```bash
   git init
   git add -A
   git commit -m "feat: initial Spring Boot app with users endpoint"
   git tag initial
   git branch -M main
   git remote add origin <URL_DU_REPO>
   git push -u origin main
   git push origin initial
   ```

## Pendant le test

Une fois que le candidat a créé sa branche et commence à coder, exécutez le script de push force :

```bash
./scripts/push-force.sh
```

Ce script modifie `UserController.java` sur main :
- Renomme `/api/users` en `/api/v1/users`
- Ajoute un paramètre de filtre par nom
- Ajoute `findByNameContainingIgnoreCase` au repository

Cela provoquera un **conflit** lorsque le candidat rebasera sa branche.

## Après le test

Réinitialisez le repo pour le prochain candidat :

```bash
./scripts/reset-repo.sh
```

## Solution attendue

### Test unitaire (Mockito)

Le candidat doit créer un test dans `src/test/java/com/eval/testtech/controller/UserControllerTest.java` :

```java
package com.eval.testtech.controller;

import com.eval.testtech.model.User;
import com.eval.testtech.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class UserControllerTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserController userController;

    @Test
    void getUserById_shouldReturnUser_whenUserExists() {
        User user = new User();
        user.setId(1L);
        user.setName("Alice Martin");
        user.setEmail("alice.martin@example.com");

        when(userRepository.findById(1L)).thenReturn(Optional.of(user));

        ResponseEntity<User> response = userController.getUserById(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isNotNull();
        assertThat(response.getBody().getName()).isEqualTo("Alice Martin");
    }

    @Test
    void getUserById_shouldReturn404_whenUserNotFound() {
        when(userRepository.findById(99L)).thenReturn(Optional.empty());

        ResponseEntity<User> response = userController.getUserById(99L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
    }
}
```

### Implémentation du contrôleur

Le candidat doit ajouter la méthode suivante dans `UserController.java` :

```java
@GetMapping("/{id}")
public ResponseEntity<User> getUserById(@PathVariable Long id) {
    return userRepository.findById(id)
            .map(ResponseEntity::ok)
            .orElse(ResponseEntity.notFound().build());
}
```

### Lancement des tests

```bash
mvn test
```

Ou pour lancer uniquement le test du contrôleur :

```bash
mvn test -Dtest=UserControllerTest
```

> **Note** : Le test `TestTechApplicationTests` (contextLoads) nécessite une base PostgreSQL. Pour ne lancer que les tests unitaires sans base de données, utiliser la commande ci-dessus avec `-Dtest=UserControllerTest`.

### Après le rebase

Suite au push force de l'examinateur, le candidat devra :
1. Récupérer le nouveau main : `git fetch origin`
2. Rebaser : `git rebase origin/main`
3. Résoudre le conflit dans `UserController.java` : conserver le renommage `/api/v1/users` ET sa nouvelle méthode `getUserById`
4. L'endpoint final sera `GET /api/v1/users/{id}` (et non `/api/users/{id}`)

### Vérification finale

```bash
docker-compose up --build
curl http://localhost:8080/api/v1/users
curl http://localhost:8080/api/v1/users/1
```

## Grille d'évaluation

| Compétence | Critère | Points |
|---|---|---|
| **Mockito** | Test unitaire avec mock du repository | /5 |
| **Mockito** | Cas nominal + cas d'erreur (404) | /3 |
| **Spring** | Endpoint GET /api/users/{id} fonctionnel | /3 |
| **Spring** | Gestion correcte du 404 (ResponseEntity ou exception) | /2 |
| **Spring** | Injection de dépendances propre | /2 |
| **Git** | Création de branche feature | /1 |
| **Git** | Rebase sur main réussi | /3 |
| **Git** | Résolution de conflits propre | /3 |
| **Docker** | L'application se lance avec docker-compose | /2 |
| **Docker** | curl sur le nouvel endpoint retourne le bon résultat | /1 |
| | **Total** | **/25** |
