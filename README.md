# IA Productos — Tema 12: Consumir una API de IA (LLM)

Mini-app web en Java (JSP + Servlets) que envía texto a un modelo de IA (Groq) y muestra la
respuesta en pantalla. Todo gira alrededor del ejemplo **"productos"**. SENA ADSO, CIMM Boyacá.

## Qué hace

- **Chat** (`/`): escribes un texto (con datos de un producto o sin ellos) y la IA responde.
- **Comparador** (`/comparar`): dos paneles independientes, cada uno con su propio prompt y su
  botón de enviar; cada lado genera su propia respuesta al lado de la otra.
- **Generador de prompts** (`/prompts.jsp`): escribes qué quieres lograr con tu producto,
  eliges el objetivo (ficha, venta, reseña, guion, SEO, comparación) y la IA devuelve un prompt
  listo para copiar, con botones para llevarlo al chat o abrirlo en el Comparador.

## Para explicarlo en clase (3 pasos)

1. **El navegador** manda el texto que escribiste a un Servlet (`/ia`).
2. **El Servlet** arma un JSON sencillo `{model, messages, max_tokens}` y lo envía por HTTPS
   a la API de Groq, con la key en la cabecera `Authorization: Bearer …`.
3. **Groq responde** con la respuesta y los tokens consumidos, y la app la pinta en pantalla.

Y los prompts: el mensaje `system` (la orden de `Instrucciones.BASE`) + el mensaje `user`
(tu pregunta). Cambiando **cómo preguntas** —en el chat, con dos prompts distintos en el
Comparador o con el Generador— cambia la respuesta que devuelve la IA.

## Requisitos

- Java 17, Maven, NetBeans (o cualquier IDE) y Tomcat 9.
- Una API key gratis de Groq: https://console.groq.com/keys

## Instalación (5 pasos)

1. Clona el repo.
2. Copia `src/main/resources/config.properties.example` a
   `src/main/resources/config.properties` (ese archivo NO se sube a Git).
3. Pega tu key: `GROQ_API_KEY=gsk_tu_clave_aqui`.
4. En NetBeans: Run sobre el proyecto (usa Tomcat 9.0.120, puerto **8082**).
5. Abre `http://localhost:8082/ia-productos/` (Ctrl+F5 si no ves cambios).

## Detalles técnicos

- Modelo: `qwen/qwen3.8-27b` (gratis, ver `GroqService.java`). Se cambia con 1 línea.
- La orden que se le envía al modelo vive en **`Instrucciones.java`** con 2 constantes:
  `BASE` (chat y comparador) y `GENERADOR` (el Generador de prompts, que convierte la idea
  del usuario en un prompt listo para copiar).
- `GenerarPromptServlet` (`/generar`) llama a Groq con esa orden y guarda hasta 10 prompts
  en la sesión; `IAServlet?cargar=...` los deja escritos en la caja del chat.
- Cada panel del Comparador envía su propio prompt como mensaje `user` con la misma orden
  `system`: el botón de cada lado solo consulta ese lado.
- Límites del plan gratis: 30 consultas/min, 1000/día, 8000 tokens/min. La app muestra las
  consultas restantes reales que reporta Groq.
- La key nunca va al repo: `config.properties` está en `.gitignore`.

## Límites conocidos (material de expo)

- El modelo no navega: su memoria tiene fecha de corte. La app lo advierte en cada respuesta de memoria.
- La misma pregunta puede dar respuestas distintas (no determinismo del modelo).
