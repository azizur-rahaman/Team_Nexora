# FoodFlow - Project Architecture Documentation

**FoodFlow: Reduce Waste, Save Food**

## Table of Contents
- [Overview](#overview)
- [Architecture Pattern](#architecture-pattern)
- [Project Structure](#project-structure)
- [Layers](#layers)
- [Dependencies](#dependencies)
- [Features](#features)
- [Best Practices](#best-practices)

---

## Overview

FoodFlow is a Flutter application built using **Clean Architecture** principles to ensure scalability, maintainability, and testability. The project follows a feature-first approach with clear separation of concerns across presentation, domain, and data layers.

---

## Architecture Pattern

### Clean Architecture

The project implements Uncle Bob's Clean Architecture with three main layers:

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│    (UI, BLoC, Pages, Widgets)          │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│          Domain Layer                   │
│  (Entities, UseCases, Repositories)    │
└──────────────┬──────────────────────────┘
               │
┌──────────────▼──────────────────────────┐
│           Data Layer                    │
│ (Models, DataSources, Repositories)    │
└─────────────────────────────────────────┘
```

**Key Principles:**
- **Dependency Rule**: Dependencies point inward (Presentation → Domain ← Data)
- **Abstraction**: Domain layer defines contracts, data layer implements them
- **Separation of Concerns**: Each layer has distinct responsibilities
- **Testability**: Each layer can be tested independently

---

## Project Structure

```
lib/
├── core/                          # Core functionality shared across features
│   ├── error/                     # Error handling
│   │   ├── exceptions.dart        # Exception definitions
│   │   └── failures.dart          # Failure types for error handling
│   ├── network/                   # Network utilities
│   │   └── network_info.dart      # Network connectivity interface
│   ├── usecases/                  # Base use case
│   │   └── usecase.dart           # Abstract UseCase class
│   └── utils/                     # Utility functions and helpers
│
├── features/                      # Feature modules (feature-first structure)
│   └── auth/                      # Authentication feature
│       ├── data/                  # Data layer
│       │   ├── datasources/       # Data sources (Remote/Local)
│       │   │   └── auth_remote_data_source.dart
│       │   ├── models/            # Data models (JSON serialization)
│       │   │   └── user_model.dart
│       │   └── repositories/      # Repository implementations
│       │       └── auth_repository_impl.dart
│       │
│       ├── domain/                # Domain layer (Business Logic)
│       │   ├── entities/          # Business entities
│       │   │   └── user.dart
│       │   ├── repositories/      # Repository contracts
│       │   │   └── auth_repository.dart
│       │   └── usecases/          # Business use cases
│       │       └── login.dart
│       │
│       └── presentation/          # Presentation layer (UI)
│           ├── bloc/              # Business Logic Component
│           │   ├── auth_bloc.dart
│           │   ├── auth_event.dart
│           │   └── auth_state.dart
│           ├── pages/             # Screen pages
│           │   └── login_page.dart
│           └── widgets/           # Reusable UI components
│
├── injection_container.dart       # Dependency Injection setup (GetIt)
└── main.dart                      # Application entry point
```

---

## Layers

### 1. Presentation Layer

**Responsibilities:**
- User Interface (UI)
- User interactions
- State management (BLoC)
- Navigation

**Components:**
- **BLoC (Business Logic Component)**: Manages UI state and business logic
  - `Events`: User actions/intents
  - `States`: UI states
  - `Bloc`: Event-to-state transformation
- **Pages**: Full-screen views
- **Widgets**: Reusable UI components

**Example:**
```dart
// auth_bloc.dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Login login;
  
  AuthBloc({required this.login}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
  }
}
```

---

### 2. Domain Layer

**Responsibilities:**
- Business logic
- Business entities
- Use cases (business rules)
- Repository interfaces

**Components:**
- **Entities**: Pure business objects (no dependencies)
- **UseCases**: Single responsibility business operations
- **Repositories**: Abstract contracts for data access

**Example:**
```dart
// login.dart
class Login implements UseCase<User, LoginParams> {
  final AuthRepository repository;
  
  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }
}
```

**Key Points:**
- Domain layer has NO dependencies on other layers
- Uses abstract repositories
- Returns `Either<Failure, Success>` for error handling

---

### 3. Data Layer

**Responsibilities:**
- Data retrieval and storage
- API communication
- Local database operations
- Data transformation

**Components:**
- **Models**: Data transfer objects (DTO) with JSON serialization
- **DataSources**: Abstract and concrete data sources
  - Remote: API calls
  - Local: Database, SharedPreferences, etc.
- **Repository Implementations**: Concrete implementations of domain repositories

**Example:**
```dart
// auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await remoteDataSource.login(email, password);
      return Right(user);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
```

---

## Dependencies

### Core Dependencies

```yaml
dependencies:
  # State Management
  flutter_bloc: ^8.1.6          # BLoC pattern implementation
  equatable: ^2.0.5             # Value equality for objects
  
  # Functional Programming
  dartz: ^0.10.1                # Functional programming (Either, Option)
  
  # Network
  http: ^1.2.0                  # HTTP client
  
  # Dependency Injection
  get_it: ^8.0.3                # Service locator
  
  # Network Info
  internet_connection_checker: ^3.0.1  # Network connectivity
```

### Purpose of Each Dependency

| Dependency | Purpose |
|-----------|---------|
| `flutter_bloc` | State management using BLoC pattern |
| `equatable` | Simplifies equality comparisons for entities and events |
| `dartz` | Provides `Either` type for functional error handling |
| `http` | Making HTTP requests to REST APIs |
| `get_it` | Dependency injection / Service locator pattern |
| `internet_connection_checker` | Check network connectivity status |

---

## Features

### Authentication Feature

**Structure:**
```
features/auth/
├── data/
│   ├── datasources/
│   │   └── auth_remote_data_source.dart    # API calls
│   ├── models/
│   │   └── user_model.dart                 # JSON ↔ Model
│   └── repositories/
│       └── auth_repository_impl.dart        # Repository implementation
├── domain/
│   ├── entities/
│   │   └── user.dart                        # Business entity
│   ├── repositories/
│   │   └── auth_repository.dart             # Abstract repository
│   └── usecases/
│       └── login.dart                       # Login use case
└── presentation/
    ├── bloc/
    │   ├── auth_bloc.dart                   # BLoC
    │   ├── auth_event.dart                  # Events
    │   └── auth_state.dart                  # States
    ├── pages/
    │   └── login_page.dart                  # Login screen
    └── widgets/                             # Reusable widgets
```

**Flow:**
1. User interacts with `LoginPage`
2. Page dispatches `LoginRequested` event to `AuthBloc`
3. Bloc calls `Login` use case
4. Use case calls `AuthRepository.login()`
5. Repository implementation calls `AuthRemoteDataSource`
6. Data source makes API call
7. Response flows back through layers
8. Bloc emits new state
9. UI updates based on state

---

## Dependency Injection

Using **GetIt** for dependency injection:

```dart
// injection_container.dart
final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => AuthBloc(login: sl()));
  
  // Use cases
  sl.registerLazySingleton(() => Login(sl()));
  
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  
  // External
  sl.registerLazySingleton(() => http.Client());
}
```

**Registration Types:**
- `registerFactory`: Creates new instance each time
- `registerLazySingleton`: Single instance, created when first needed
- `registerSingleton`: Single instance, created immediately

---

## Best Practices

### 1. **Error Handling**
- Use `Either<Failure, Success>` from dartz
- Define specific failure types
- Handle exceptions at repository level

```dart
Future<Either<Failure, User>> login() async {
  try {
    final user = await remoteDataSource.login();
    return Right(user);
  } on ServerException {
    return Left(ServerFailure());
  } on NetworkException {
    return Left(NetworkFailure());
  }
}
```

### 2. **Immutability**
- Use `const` constructors where possible
- Make all fields `final`
- Use `Equatable` for value equality

```dart
class User extends Equatable {
  final String id;
  final String email;
  
  const User({required this.id, required this.email});
  
  @override
  List<Object?> get props => [id, email];
}
```

### 3. **Single Responsibility**
- One use case per business operation
- Keep widgets small and focused
- Separate concerns across layers

### 4. **Testing**
- Unit test: Domain layer (use cases, entities)
- Widget test: Presentation layer
- Integration test: Full feature flows

### 5. **Naming Conventions**
- Events: `NounVerbed` (e.g., `LoginRequested`)
- States: `NounAdjective` (e.g., `AuthAuthenticated`)
- Use cases: `Verb` (e.g., `Login`, `Logout`)
- Repositories: `NounRepository` (e.g., `AuthRepository`)

---

## Adding New Features

To add a new feature, follow this structure:

1. **Create feature folder**:
   ```
   features/new_feature/
   ├── data/
   ├── domain/
   └── presentation/
   ```

2. **Domain layer** (business logic first):
   - Define entities
   - Create repository interface
   - Implement use cases

3. **Data layer** (implementation):
   - Create models
   - Implement data sources
   - Implement repository

4. **Presentation layer** (UI):
   - Create BLoC (events, states, bloc)
   - Build pages
   - Create widgets

5. **Dependency Injection**:
   - Register all dependencies in `injection_container.dart`

---

## Code Quality

### Linting
- Using `flutter_lints: ^5.0.0`
- Configured in `analysis_options.yaml`

### Code Style
- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use meaningful variable names
- Keep functions small and focused
- Add documentation comments for public APIs

---

## Resources

- [Clean Architecture by Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter BLoC Documentation](https://bloclibrary.dev/)
- [Effective Dart Style Guide](https://dart.dev/guides/language/effective-dart)
- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)

---

## License

[Add your license information here]

---

**FoodFlow Team**  
*Reduce Waste, Save Food* 🌱
