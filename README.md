<p align="center">
  <img src="docs/assets/sportfactory-logo.png" alt="SportFactory Gym logo" width="320">
</p>

# SportFactory App

**Android + web platform for gym management.** SportFactory App lets the members of *SportFactory Gym* (Sanlúcar de Barrameda, Spain) book classes, follow their training routines and progress, and receive the centre's announcements, while trainers and reception staff manage schedules, bookings and notices from a web panel.

> Proyecto Intermodular · DAM (Multiplatform Application Development), 2nd year · Victoria Institute of Technology

## Project status

The project is in its **documentation and design phase**. No application code has been written yet; the first iteration starts after the design stage. This repository contains the project structure, the team workflow and the documentation delivered so far.

## Planned features

- Member sign-up and login with role-based access (member, trainer, reception).
- Digital membership card with QR code.
- Class timetable with booking, cancellation and capacity control.
- Routines and exercises assigned by the trainer.
- Progress tracking (weight, measurements, personal records) with charts.
- Push notifications and announcements from the gym.
- Web panel for trainers and reception, plus a public web page for the gym.

## Tech stack

| Layer | Technology |
|---|---|
| Android app | Kotlin, Jetpack Compose |
| REST API | Java 21, Spring Boot, Spring Security (JWT), Spring Data JPA |
| Database | PostgreSQL |
| Web | TypeScript, React, Vite |
| Notifications | Firebase Cloud Messaging |
| Design | Figma |
| Testing | JUnit 5, Postman |
| Deployment | Docker, Google Play |

## Repository structure

```
Proyecto_Factory_Gym/
├── app/    Android application (Kotlin + Jetpack Compose)
├── api/    REST API (Spring Boot + PostgreSQL)
├── web/    Web panel and public site (React + TypeScript)
├── docs/   Project documentation and visual identity
└── .github/  Pull request template
```

## Documentation

- [Project document: methodology, tools and technologies](docs/PI_DAM2_SportFactoryApp_Metodologia.pdf)
- [Visual identity and initial presentation](docs/DAM_ProyectoIntermodular_IdentidadVisual_SportFactory.pdf)

## Team

| Name | Role |
|---|---|
| [Gonzalo Castellano Ruiz](https://github.com/GonzaloCastellano19) | Developer |
| Miguel Gómez Fernández | Developer |

**Tutor:** Patricia Pazos Pousada

## Workflow

We work with Kanban boards in Trello and the GitHub flow (one branch per feature, pull requests with peer review). See [CONTRIBUTING.md](CONTRIBUTING.md).
