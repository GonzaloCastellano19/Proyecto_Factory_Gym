<p align="center">
  <img src="docs/assets/sportfactory-logo.png" alt="Logo de SportFactory Gym" width="320">
</p>

# SportFactory App

**Plataforma Android + web para la gestión de un gimnasio.** SportFactory App permite a los socios de *SportFactory Gym* (Sanlúcar de Barrameda) reservar clases, seguir sus rutinas y su progreso y recibir los avisos del centro, mientras que monitores y recepción gestionan horarios, reservas y avisos desde un panel web.

> Proyecto Intermodular · DAM (Desarrollo de Aplicaciones Multiplataforma), 2.º curso · Victoria Institute of Technology

## Estado del proyecto

El proyecto se encuentra en la **fase de documentación y diseño**. Todavía no se ha escrito código de la aplicación; la primera iteración comenzará tras la fase de diseño. Este repositorio contiene la estructura del proyecto, la forma de trabajo del equipo y la documentación entregada hasta ahora.

## Funcionalidades previstas

- Registro e inicio de sesión de socios con acceso por roles (socio, monitor, recepción).
- Carnet digital con código QR.
- Horario de clases con reserva, cancelación y control de aforo.
- Rutinas y ejercicios asignados por el monitor.
- Seguimiento del progreso (peso, medidas, marcas personales) con gráficas.
- Notificaciones push y avisos del gimnasio.
- Panel web para monitores y recepción, y página web pública del gimnasio.

## Tecnologías

| Capa | Tecnología |
|---|---|
| Aplicación Android | Kotlin, Jetpack Compose |
| API REST | Java 21, Spring Boot, Spring Security (JWT), Spring Data JPA |
| Base de datos | PostgreSQL |
| Web | TypeScript, React, Vite |
| Notificaciones | Firebase Cloud Messaging |
| Diseño | Figma |
| Pruebas | JUnit 5, Postman |
| Despliegue | Docker, Google Play |

## Estructura del repositorio

```
Proyecto_Factory_Gym/
├── app/    Aplicación Android (Kotlin + Jetpack Compose)
├── api/    API REST (Spring Boot + PostgreSQL)
├── web/    Panel web y página pública (React + TypeScript)
├── docs/   Documentación del proyecto e identidad visual
└── .github/  Plantilla de pull requests
```

## Documentación

- [Documento del proyecto: metodología, herramientas y tecnologías](docs/PI_DAM2_SportFactoryApp_Metodologia.pdf)
- [Identidad visual y presentación inicial](docs/DAM_ProyectoIntermodular_IdentidadVisual_SportFactory.pdf)

## Equipo

| Nombre | Rol |
|---|---|
| [Gonzalo Castellano Ruiz](https://github.com/GonzaloCastellano19) | Desarrollador |
| Miguel Gómez Fernández | Desarrollador |

**Tutora:** Patricia Pazos Pousada

## Forma de trabajo

Trabajamos con tableros Kanban en Trello y con el flujo de GitHub (una rama por funcionalidad, pull requests con revisión entre compañeros). Consulta [CONTRIBUTING.md](CONTRIBUTING.md).
