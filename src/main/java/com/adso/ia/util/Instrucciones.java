package com.adso.ia.util;

public final class Instrucciones {

    private Instrucciones() {
    }

    public static final String BASE =
            "Eres Nexus, un asistente útil y directo. Respondes en español neutro, sin rodeos, "
            + "sin saludos largos y sin adjetivos emocionales. "
            + "Respondes a cualquier pregunta: productos, precios, comparaciones, técnicas, "
            + "trabajo, estudio, ideas o temas cotidianos. "
            + "Reglas: "
            + "1) Empieza SIEMPRE por la respuesta. Nunca abras ni cierres el mensaje con "
            + "disculpas ni con frases como «no tengo datos en tiempo real», «no puedo indicar "
            + "el valor exacto» o «debes consultar la fuente oficial». "
            + "2) Si no recuerdas un dato exacto (precio, tipo de cambio, ventas, rankings), "
            + "da tu mejor estimado conocido, empezando por «aproximadamente» y con la fecha "
            + "aproximada que recuerdes; solo al final, en UNA frase, avisa que debe verificarse. "
            + "3) Si te dan datos de un producto, basate en ellos y menciónalos. "
            + "4) Si te piden un contenido (ficha técnica, reseña, anuncio, guion, comparación), "
            + "entrégalo listo para copiar y usar. "
            + "5) Separa las ideas con saltos de línea.";

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

    public static final String PROMPT_PRUEBA_1 =
            "Escribe un correo para pedir trabajo";

    public static final String PROMPT_PRUEBA_2 =
            "Actúa como un asesor de empleabilidad con experiencia en procesos de selección en Colombia.\n"
            + "\n"
            + "Necesito un correo para enviar a la jefa de talento humano de una empresa de "
            + "tecnología llamada \"TechAndes\", solicitando una oportunidad de etapa práctica "
            + "como aprendiz de Análisis y Desarrollo de Software.\n"
            + "\n"
            + "Datos que debe incluir:\n"
            + "- Mi nombre: Laura Gómez\n"
            + "- Estoy por terminar el Tecnólogo en Análisis y Desarrollo de Software en el SENA\n"
            + "- Manejo Java, SQL y trabajo en equipo con Git\n"
            + "- Adjunto mi hoja de vida en PDF\n"
            + "- Saber Trabajo en equipo\n"
            + "\n"
            + "Requisitos:\n"
            + "- Tono formal pero cercano, sin frases exageradas.\n"
            + "- Máximo 200 palabras.\n"
            + "- Incluye un asunto claro y una despedida cordial.\n"
            + "- Termina pidiendo una breve reunión o llamada.\n"
            + "- Resalta mis habilidades\n"
            + "\n"
            + "Entrégalo listo para copiar y pegar, sin explicaciones adicionales.";

    public static String paraTextarea(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }

    public static String paraAtributo(String s) {
        if (s == null) return "";
        return paraTextarea(s).replace("\"", "&quot;").replace("'", "&#39;");
    }
}