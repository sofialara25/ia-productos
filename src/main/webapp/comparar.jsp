<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.adso.ia.model.RespuestaIA" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Nexus</title>
        <link rel="stylesheet" href="nexus.css">
    </head>
    <body>
        <% pageContext.setAttribute("paginaActiva", "comparar"); %>
        <%@ include file="sidebar.jspf" %>

    <!-- COMPARADOR -->
    <div class="chat-container">
        <div class="chat-header">
            <span class="chat-title">
                <svg class="icon" viewBox="0 0 24 24"><path d="M16 3h5v5"/><path d="M21 3l-7 7"/><path d="M8 21H3v-5"/><path d="M3 21l7-7"/><path d="M21 16v5h-5"/><path d="M3 8V3h5"/></svg>
                Comparador
            </span>
            <div style="margin-left:auto;display:flex;flex-direction:column;align-items:flex-end;gap:2px;">
            <a href="comparar?limpiar=1" title="Limpiar los paneles y empezar de cero" style="background:var(--bg-card);border:1px solid var(--border-color);border-radius:20px;padding:5px 14px;font-size:0.8rem;color:var(--accent-blue);text-decoration:none;">Limpiar</a>
            <% Object cR = session.getAttribute("consultasRestantes"); Object cL = session.getAttribute("limiteConsultas"); %>
            <small style="color:var(--text-muted);font-size:0.72rem;" title="Dato real enviado por Groq en cada respuesta">⏳ <%= (cR instanceof Integer && (Integer) cR >= 0) ? cR + "/" + cL + " consultas restantes hoy" : "Cuota: 1000 consultas por día" %></small>
            </div>
        </div>

        <!-- PANELES DIVIDIDOS: mismo prompt, un tipo por lado -->
        <div class="chat-messages" id="chatMessages">
            <style>
                .cmp-wrap { display:flex; gap:12px; width:100%; flex:1; align-items:stretch; min-height:60vh; }
                .cmp-panel { flex:1; display:flex; flex-direction:column; background:var(--bg-card); border:1px solid var(--border-color); border-radius:10px; padding:12px; overflow-y:auto; min-height:320px; }
                .cmp-panel h4 { color:var(--accent-blue); }
                .cmp-panel small { color:var(--text-muted); }
                .cmp-select { border:1px solid var(--border-color); border-radius:20px; padding:6px 14px; font-size:0.85rem; background:var(--chat-user-bg); color:var(--accent-blue); }
                .cmp-hint { color:var(--text-muted); }
                @media (max-width: 700px) { .cmp-wrap { flex-direction:column; } }
            </style>
            <% if (request.getAttribute("error") != null || session.getAttribute("error") != null) { %>
            <p style="color:#fff;background:#C0392B;border-radius:8px;padding:10px;">${error}</p>
            <% } %>
            <div class="cmp-wrap">
                <div class="cmp-panel">
                    <div style="display:flex;justify-content:flex-start;margin-bottom:8px;">
                        <% String tipoAVal = (String) request.getAttribute("tipoAVal"); if (tipoAVal == null) tipoAVal = (String) session.getAttribute("tipoAVal"); if (tipoAVal == null) tipoAVal = "publicitario"; %>
                        <select name="tipoA" form="cmpForm" title="Tipo de respuesta izquierda" class="cmp-select">
                            <option value="normal" <%= "normal".equals(tipoAVal) ? "selected" : "" %>>Normal</option>
                            <option value="tecnico" <%= "tecnico".equals(tipoAVal) ? "selected" : "" %>>Técnico</option>
                            <option value="publicitario" <%= "publicitario".equals(tipoAVal) ? "selected" : "" %>>Publicitario</option>
                            <option value="resena" <%= "resena".equals(tipoAVal) ? "selected" : "" %>>Reseña</option>
                            <option value="seo" <%= "seo".equals(tipoAVal) ? "selected" : "" %>>SEO</option>
                        </select>
                    </div>
                    <% com.adso.ia.model.RespuestaIA rA = (com.adso.ia.model.RespuestaIA) request.getAttribute("respuestaA"); if (rA == null) rA = (com.adso.ia.model.RespuestaIA) session.getAttribute("respuestaA"); if (rA != null) { %>
                    <h4>Izquierda · ${tipoA}</h4>
                    <p style="flex:1;"><%= rA.getTextoHtml() %></p>
                    <small>Tokens: ${respuestaA.tokensTotal}</small>
                    <% } else { %>
                    <p class="cmp-hint">Aquí saldrá la respuesta izquierda…</p>
                    <% } %>
                </div>
                <div class="cmp-panel">
                    <div style="display:flex;justify-content:flex-end;margin-bottom:8px;">
                        <% String tipoBVal = (String) request.getAttribute("tipoBVal"); if (tipoBVal == null) tipoBVal = (String) session.getAttribute("tipoBVal"); if (tipoBVal == null) tipoBVal = "normal"; %>
                        <select name="tipoB" form="cmpForm" title="Tipo de respuesta derecha" class="cmp-select">
                            <option value="normal" <%= "normal".equals(tipoBVal) ? "selected" : "" %>>Normal</option>
                            <option value="tecnico" <%= "tecnico".equals(tipoBVal) ? "selected" : "" %>>Técnico</option>
                            <option value="publicitario" <%= "publicitario".equals(tipoBVal) ? "selected" : "" %>>Publicitario</option>
                            <option value="resena" <%= "resena".equals(tipoBVal) ? "selected" : "" %>>Reseña</option>
                            <option value="seo" <%= "seo".equals(tipoBVal) ? "selected" : "" %>>SEO</option>
                        </select>
                    </div>
                    <% com.adso.ia.model.RespuestaIA rB = (com.adso.ia.model.RespuestaIA) request.getAttribute("respuestaB"); if (rB == null) rB = (com.adso.ia.model.RespuestaIA) session.getAttribute("respuestaB"); if (rB != null) { %>
                    <h4>${tipoB} · Derecha</h4>
                    <p style="flex:1;"><%= rB.getTextoHtml() %></p>
                    <small>Tokens: ${respuestaB.tokensTotal}</small>
                    <% } else { %>
                    <p class="cmp-hint">Aquí saldrá la respuesta derecha…</p>
                    <% }%>
                </div>
            </div>
        </div>

        <!-- INPUT ÚNICO: un prompt para los dos lados -->
        <div class="chat-input-area">
            <div class="input-box-wrapper">
                <form id="cmpForm" action="comparar" method="post">
                    <textarea placeholder="Ej: Producto: Audífonos $150.000, batería 20h. Descríbelo." rows="1" id="userInput" name="pregunta">${pregunta}</textarea>

                    <!-- MARCA DE AGUA -->
                    <div class="input-watermark">
                        Nexus es una IA y puede cometer errores.
                    </div>

                    <!-- BOTÓN ENVIAR -->
                    <button class="send-btn" type="submit" aria-label="Enviar mensaje">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="22" y1="2" x2="11" y2="13"></line>
                        <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                        </svg>
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- JAVASCRIPT -->
    <script>
        function sendMessage() {
            // Envío real: el form hace POST al Servlet /comparar
            document.getElementById('cmpForm').submit();
        }

        // Tema claro/oscuro: guarda tu elección en el navegador
        // (los íconos de luna/sol se alternan por CSS con la clase "dark")
        function toggleTheme() {
            var dark = !document.body.classList.contains('dark');
            document.body.classList.toggle('dark', dark);
            localStorage.setItem('nexus-theme', dark ? 'dark' : 'light');
        }
        (function () {
            if (localStorage.getItem('nexus-theme') === 'dark') {
                document.body.classList.add('dark');
            }
        })();

        const textarea = document.getElementById('userInput');
        textarea.addEventListener('input', function () {
            this.style.height = 'auto';
            this.style.height = Math.min(this.scrollHeight, 150) + 'px';
        });

        textarea.addEventListener('keydown', function (e) {
            if (e.key === 'Enter' && !e.shiftKey) {
                e.preventDefault();
                sendMessage();
            }
        });

        // Al cargar, baja solo hasta el final del contenido
        var cm = document.getElementById('chatMessages');
        if (cm) { cm.scrollTop = cm.scrollHeight; }
    </script>
</body>
</html>