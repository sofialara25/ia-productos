package com.adso.ia.model;

// Lo que devuelve Groq después de una consulta: el texto de la respuesta
// y cuántos tokens (unidades de texto) se consumieron.
public class RespuestaIA implements java.io.Serializable {

    private static final long serialVersionUID = 1L;

    private final String texto;
    private final int tokens;
    private int consultasRestantes = -1; // cuota que reporta Groq (-1 si no vino)
    private int limiteConsultas = -1;

    public RespuestaIA(String texto, int tokens) {
        this.texto = texto;
        this.tokens = tokens;
    }

    // Consultas que quedan hoy según las cabeceras de la API de Groq
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

    // Texto listo para pintarlo en el JSP: escapa el HTML (seguridad)
    // y convierte el markdown básico (negrillas y viñetas).
    public String getTextoHtml() {
        if (texto == null) return "";
        String h = texto.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;");
        h = h.replaceAll("\\*\\*(.+?)\\*\\*", "<strong>$1</strong>");
        h = h.replaceAll("(?m)^\\* ", "• ");
        h = h.replace("\n", "<br>");
        return h;
    }
}
