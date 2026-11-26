# SportFactory Gym · prototipo web

Requisitos: Node.js 14 o superior. No hay que instalar nada (`npm install` no es necesario).

```bash
npm start
```

Abre http://localhost:3000 (versión creativa) o http://localhost:3000/clasica (versión clásica).
Para usar otro puerto: `PORT=8080 npm start` (en PowerShell: `$env:PORT=8080; npm start`).

Las fuentes y la biblioteca de Supabase se cargan por internet, así que hace falta conexión.

## Conectar con Supabase (opcional)

Sin configurar nada, la web funciona en **modo simulado** (datos de ejemplo y login de mentira).
Para usar una base de datos y cuentas reales:

1. En Supabase abre **SQL Editor → New query**, pega el contenido de [`supabase/schema.sql`](supabase/schema.sql) y pulsa **Run**.
   Crea las tablas, las reglas de seguridad (RLS), las funciones de reservar/cancelar con control de aforo y el horario de ejemplo.
2. En **Project Settings → API** copia la clave **anon / publishable** y pégala en [`public/config.js`](public/config.js).
   La URL del proyecto ya está puesta. **Nunca** pongas la clave `service_role`.
3. En **Authentication → URL Configuration** pon `http://localhost:3000` como *Site URL*.
   En **Authentication → Sign In / Providers → Email**, la opción *Confirm email* puede desactivarse mientras se hacen pruebas.
4. Reinicia el servidor (`Ctrl + C` y `npm start`) y recarga la página.

Qué cambia en modo Supabase:
- El login y el registro usan **Supabase Auth** (correo y contraseña).
- Las plazas se leen de la vista `sessions_with_taken` y se refrescan cada 20 segundos.
- Reservar y cancelar llaman a las funciones `book_session` y `cancel_booking`. Cada socio solo ve sus reservas.

Limitación del prototipo: el horario es semanal (sin fechas concretas). En la versión final cada reserva irá ligada a una fecha.
