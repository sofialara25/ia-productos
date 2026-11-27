package com.adso.ia.model;

public class RespuestaIA implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    private final String texto;
    private final int tokens;
    private int consultasRestantes = -1;
    private int limiteConsultas = -1;

    public RespuestaIA(String texto, int tokens) {
        this.texto = texto;
        this.tokens = tokens;
    }

    public void setCuotaConsultas(int restantes, int limite) {
        this.consultasRestantes = restantes;
        this.limiteConsultas = limite;
    }

    public int getConsultasRestantes() {
        return consultasRestantes;
    }

    public int getLimiteConsultas() {
        return limiteConsultas;
    }

    public String getTexto() {
        return texto;
    }

    public int getTokens() {
        return tokens;
    }

    public String getTextoHtml() {
        if (texto == null) return "";
        String h = texto.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
        h = h.replaceAll("\\*\\*(.+?)\\*\\*", "<strong>$1</strong>");
        h = h.replaceAll("(?m)^\\* ", "• ");
        h = h.replace("\n", "<br>");
        return h;
    }
}