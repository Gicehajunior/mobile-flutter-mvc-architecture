# Mobile Flutter MVC Architecture

**Technical Engineering Documentation**

## 1. Purpose of This Document

This document describes the architectural design, engineering principles, and implementation patterns used in the **mobile-flutter-mvc-architecture** project.

It is intended for:

* Flutter engineers extending or maintaining the codebase
* Architects reviewing design decisions
* Contributors onboarding into the project
* Technical reviewers assessing maintainability and scalability

This is **not** an end-user guide. It focuses strictly on **engineering and architectural concerns**.



## 2. Architectural Overview

The project implements a **structured MVC-based architecture** for Flutter, augmented with:

* Explicit dependency assembly
* Controlled state ownership
* Predictable lifecycle management
* Clear separation of responsibilities

High-level flow:

```
UI (Widgets)
   ↓
Controllers
   ↓
Repositories / Services
   ↓
Data Sources (API, Local Storage)
```

State management and dependency wiring are **explicit by design**, not implicit.



## 3. Core Design Principles

### 3.1 Explicit Dependency Assembly

Dependencies are constructed deliberately rather than resolved implicitly.

* Widgets may act as **composition roots**
* No hidden global dependency resolution
* No uncontrolled service locators

This improves:

* Testability
* Debuggability
* Long-term maintainability



### 3.2 Predictable Ownership and Lifecycle

Every object in the system has a **clear owner**.

| Object Type | Owner                              |
| -- | - |
| Controller  | UI / Composition Root              |
| Repository  | Controller or Widget               |
| Provider    | Provider Registry / Explicit Scope |
| State       | Provider                           |

This prevents:

* Zombie providers
* Memory leaks
* Unsafe `BuildContext` usage
* Invalid `ref` access during disposal



### 3.3 UI Is Not Business Logic

Widgets are responsible for:

* Rendering state
* Wiring dependencies
* Triggering controller actions

Widgets **must not**:

* Contain business rules
* Fetch data directly
* Perform domain transformations



## 4. MVC Interpretation in Flutter

This project applies a **Flutter-appropriate interpretation of MVC**, not a textbook implementation.



### 4.1 Model

Models are **pure data structures**, such as:

* DTOs
* API response models
* Domain entities

Models:

* Contain no state logic
* Are serialization-friendly



### 4.2 View (Widgets)

Views:

* Are stateless where possible
* Consume providers
* Delegate actions to controllers

A View **may act as a composition root**, meaning it:

* Assembles controllers and repositories
* Injects dependencies downward

This is **intentional and valid**, not an architectural violation.



### 4.3 Controller

Controllers:

* Coordinate business logic
* Orchestrate repositories
* Mutate state through providers

Controllers **do not**:

* Depend on `BuildContext`
* Render UI
* Own providers



## 5. Dependency Injection Strategy

### 5.1 No Global DI Container

The architecture deliberately avoids:

* Global service locators
* Implicit singleton resolution

Instead, it uses:

* Constructor injection
* Explicit wiring at composition roots



### 5.2 Composition Roots

A **composition root** is where dependencies are assembled.

Typical examples:

* Feature entry widgets
* Navigation boundaries
* Module bootstrap widgets

Responsibilities include:

* Instantiating repositories
* Instantiating controllers
* Passing dependencies into widgets

This mirrors:

* ViewModel factories
* DI container entry points



## 6. Provider Registry Pattern

The architecture introduces a **Provider Registry** abstraction to:

* Register providers dynamically
* Track disposable vs persistent providers
* Centralize lifecycle control



### 6.1 Why the Registry Exists

Riverpod providers:

* Are global by default
* Persist unless explicitly invalidated
* Can outlive widgets unintentionally

The registry restores **scope control** by:

* Centralizing invalidation
* Preventing provider leakage
* Making lifetimes explicit



### 6.2 Disposable Providers

Some providers are:

* Feature-scoped
* Temporary
* UI-lifecycle bound

Such providers:

* Are registered as `disposable`
* Must be invalidated explicitly
* Must never be accessed after disposal



## 7. Lifecycle Management Rules

### 7.1 Widget Lifecycle Safety

Strict rules apply:

* `ref.read`, `ref.refresh`, and `ref.invalidate` **must not be called** after widget deactivation
* Async callbacks must verify provider validity
* Delayed operations must not assume widget existence

Violations result in:

* Runtime exceptions
* Undefined behavior
* Hard-to-debug crashes



### 7.2 Provider Disposal Strategy

Providers are disposed via:

* Explicit invalidation
* Registry-driven cleanup
* Feature exit boundaries

Providers must **not**:

* Dispose themselves implicitly
* Depend on `BuildContext`
* Outlive their owning feature



## 8. Async Operations and Safety

### 8.1 Async Boundaries

Async logic:

* Lives in controllers or repositories
* Never captures `BuildContext`
* Is cancellation-safe where applicable



### 8.2 Timers and Delayed Execution

Timers:

* Are provider-owned
* Verify provider validity before mutation
* Terminate on disposal



## 9. Maintainability Considerations

This architecture intentionally avoids:

* Implicit dependency resolution
* Over-abstracted state layers
* Framework-driven magic

Accepted trade-offs:

* Slightly more boilerplate
* Explicit wiring code

Benefits gained:

* Predictable behavior
* Safer `ref` usage
* Easier refactoring
* Clear debugging paths



## 10. Testing Strategy

### 10.1 Unit Testing

Controllers and repositories:

* Are instantiated directly
* Require no Flutter bindings
* Use mocked dependencies



### 10.2 Widget Testing

Widgets:

* Receive injected controllers
* Use overridden providers
* Avoid global state bleed



## 11. Extension Guidelines

When adding a new feature:

1. Define models
2. Create repositories
3. Implement controllers
4. Register providers via the registry
5. Assemble dependencies at the composition root
6. Dispose explicitly on feature exit

Never:

* Introduce global singletons
* Access providers implicitly
* Store `BuildContext` outside widgets



## 12. Architectural Non-Goals

This project does **not** aim to:

* Be a Riverpod tutorial
* Enforce rigid Clean Architecture layers
* Replace Flutter’s widget tree with DI frameworks

The priority is **clarity over cleverness**.



## 13. Summary

This architecture provides:

* Explicit dependency assembly
* Clear ownership boundaries
* Safe provider lifecycle management
* A scalable Flutter MVC structure

It is optimized for **long-lived, multi-feature mobile applications** where predictability and maintainability outweigh convenience shortcuts.
