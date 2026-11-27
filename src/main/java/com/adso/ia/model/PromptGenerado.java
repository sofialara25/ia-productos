package com.adso.ia.model;

public class PromptGenerado implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    private final String idea;
    private final String objetivo;
    private final String texto;
    private final int tokens;

    public PromptGenerado(String idea, String objetivo, String texto, int tokens) {
        this.idea = idea;
        this.objetivo = objetivo;
        this.texto = texto;
        this.tokens = tokens;
    }

    public String getIdea() {
        return idea;
    }

    public String getObjetivo() {
        return objetivo;
    }

    public String getTexto() {
        return texto;
    }

    public int getTokens() {
        return tokens;
    }

    public String getIdeaHtml() {
        if (idea == null) return "";
        String t = idea.replaceAll("\\s+", " ").trim();
        if (t.length() > 90) t = t.substring(0, 90) + "…";
        return t.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }

    public String getTextoHtml() {
        if (texto == null) return "";
        return texto.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
    }
}