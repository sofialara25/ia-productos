package com.adso.ia.util;

// Mensajes "system" que se le envían al modelo.
// Están centralizados aquí para que el chat, el comparador y el generador
// usen exactamente el mismo texto.
public final class Instrucciones {

    private Instrucciones() {
    }

    // Orden única de la app: se usa en el chat y en el comparador.
    public static final String BASE =
            "Eres asistente de tienda online. Responde en español de forma neutra y directa, "
            + "sin adjetivos emocionales. Si te dan datos de un producto, basate en ellos y "
            + "menciónalos. Si no te dan datos, responde con tu conocimiento general; si preguntan "
            + "por datos actuales (precios, rankings, top de ventas), responde con lo más conocido "
            + "aclaramando que tu información puede estar desactualizada y debe verificarse. "
            + "Separa las ideas con saltos de línea.";

    // Orden del Generador de prompts: la IA recibe lo que el usuario quiere
    // lograr y devuelve un prompt listo para copiar y pegar en el chat.
    public static final String GENERADOR =
            "Eres un experto en redactar prompts para IA. El usuario te describe, en su propio "
            + "palabras, qué quiere lograr con un producto o con una tarea. Tu trabajo es "
            + "convertir esa idea en UN SOLO prompt, en español, listo para copiar y pegar en un "
            + "chat de IA. Reglas: responde únicamente con el texto del prompt, sin explicaciones, "
            + "sin saludos, sin comillas ni bloque de código. El prompt debe incluir el contexto "
            + "(datos del producto si los hay), la tarea concreta, el formato de salida esperado "
            + "(longitud, estructura, viñetas o tabla cuando aplique) y el tono. Si falta un dato "
            + "importante, déjalo marcado entre corchetes, por ejemplo [precio]. Ajusta el largo y "
            + "el enfoque del prompt al objetivo que pida el usuario.";

    // Texto seguro para pintarlo dentro de un <textarea> o de una etiqueta.
    public static String paraTextarea(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }

    // Texto seguro para un atributo HTML (también escapa las comillas dobles).
    public static String paraAtributo(String s) {
        if (s == null) return "";
        return paraTextarea(s).replace("\"", "&quot;").replace("'", "&#39;");
    }
}
