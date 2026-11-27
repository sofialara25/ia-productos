package com.adso.ia.model;

import java.io.Serializable;

public class MensajeChat implements Serializable {

    private static final long serialVersionUID = 1L;

    private final String pregunta;
    private final RespuestaIA respuesta;
    private final String error;

    public MensajeChat(String pregunta, RespuestaIA respuesta, String error) {
        this.pregunta = pregunta;
        this.respuesta = respuesta;
        this.error = error;
    }

    public RespuestaIA getRespuesta() {
        return respuesta;
    }

    public boolean isError() {
        return error != null;
    }

    public String getTituloCorto() {
        if (pregunta == null || pregunta.isBlank()) return "Chat sin título";
        String t = pregunta.replaceAll("\\s+", " ").trim();
        return t.length() <= 30 ? t : t.substring(0, 30) + "…";
    }

    public String getPreguntaHtml() {
        if (pregunta == null) return "";
        return pregunta.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")
                .replace("\n", "<br>");
    }

    public String getErrorHtml() {
        if (error == null) return "";
        return error.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}