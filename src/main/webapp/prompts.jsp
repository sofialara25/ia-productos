<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,com.adso.ia.model.PromptGenerado,com.adso.ia.util.Instrucciones" %>
<%
    // Último prompt escrito en la caja (se conserva si hubo error)
    String ideaGuardada = (String) session.getAttribute("idea");
    if (ideaGuardada == null) ideaGuardada = "";
    else session.removeAttribute("idea"); // se pinta una sola vez

    String errorGen = (String) session.getAttribute("errorGen");
    if (errorGen != null) session.removeAttribute("errorGen");

    List<PromptGenerado> generados = (List<PromptGenerado>) session.getAttribute("promptsGenerados");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Nexus</title>
        <link rel="stylesheet" href="nexus.css">
    </head>
    <body>
        <% pageContext.setAttribute("paginaActiva", "prompts"); %>
        <%@ include file="sidebar.jspf" %>

    <div class="chat-container">
        <div class="chat-header">
            <span class="chat-title">
                <svg class="icon" viewBox="0 0 24 24"><path d="M9 18h6"/><path d="M10 22h4"/><path d="M12 2a7 7 0 0 0-4 12.7c.6.5 1 1.2 1 2V17h6v-.3c0-.8.4-1.5 1-2A7 7 0 0 0 12 2z"/></svg>
                Generador de prompts
            </span>
            <div style="margin-left:auto;display:flex;flex-direction:column;align-items:flex-end;gap:2px;">
            <a href="generar?limpiar=1" title="Borrar los prompts generados" style="background:var(--bg-card);border:1px solid var(--border-color);border-radius:20px;padding:5px 14px;font-size:0.8rem;color:var(--accent-blue);text-decoration:none;">Limpiar</a>
            <% Object cR = session.getAttribute("consultasRestantes"); Object cL = session.getAttribute("limiteConsultas"); %>
            <small style="color:var(--text-muted);font-size:0.72rem;" title="Dato real enviado por Groq en cada respuesta">⏳ <%= (cR instanceof Integer && (Integer) cR >= 0) ? cR + "/" + cL + " consultas restantes hoy" : "Cuota: 1000 consultas por día" %></small>
            </div>
        </div>

        <div class="chat-messages" id="chatMessages" style="align-items:stretch;">
            <style>
                .gen-card { width:100%; background:var(--bg-card); border:1px solid var(--border-color); border-radius:10px; padding:14px; display:flex; flex-direction:column; gap:10px; }
                .gen-meta { display:flex; flex-wrap:wrap; align-items:center; gap:8px; font-size:0.75rem; color:var(--text-muted); }
                .gen-tag { background:var(--chat-user-bg); color:var(--accent-blue); border:1px solid var(--border-color); border-radius:20px; padding:3px 11px; font-weight:600; }
                .gen-idea { overflow:hidden; text-overflow:ellipsis; white-space:nowrap; max-width:100%; }
                .gen-texto { width:100%; background:var(--bg-main); border:1px solid var(--border-color); border-left:3px solid var(--accent-blue); border-radius:8px; padding:12px 13px; font-size:0.88rem; line-height:1.6; white-space:pre-wrap; word-break:break-word; color:var(--text-main); }
                .gen-actions { display:flex; flex-wrap:wrap; gap:8px; justify-content:flex-end; }
                .gen-actions button, .gen-actions a { background:var(--chat-user-bg); color:var(--accent-blue); border:1px solid var(--border-color); border-radius:20px; padding:6px 14px; font-size:0.8rem; cursor:pointer; text-decoration:none; font-family:inherit; }
                .gen-actions button:hover, .gen-actions a:hover { background:var(--accent-blue); color:#fff; }
                .gen-actions .gen-main { background:var(--accent-blue); color:#fff; font-weight:600; }
                .gen-actions .gen-main:hover { background:var(--accent-blue-hover); }
                .gen-obj { display:flex; flex-wrap:wrap; align-items:center; gap:8px; width:100%; font-size:0.8rem; color:var(--text-muted); }
                .gen-obj select { border:1px solid var(--border-color); border-radius:20px; padding:5px 10px; font-size:0.8rem; background:var(--bg-main); color:var(--accent-blue); cursor:pointer; font-family:inherit; }
            </style>

            <% if (errorGen != null) { %>
            <p style="width:100%;color:#fff;background:#C0392B;border-radius:8px;padding:10px 14px;font-size:0.85rem;"><%= Instrucciones.paraTextarea(errorGen) %></p>
            <% } %>

            <% if (generados == null || generados.isEmpty()) { %>
            <div class="welcome-screen" id="welcomeScreen">
                <div class="welcome-icon">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M9 18h6"/><path d="M10 22h4"/><path d="M12 2a7 7 0 0 0-4 12.7c.6.5 1 1.2 1 2V17h6v-.3c0-.8.4-1.5 1-2A7 7 0 0 0 12 2z"/></svg>
                </div>
                <h2>Genera tu prompt</h2>
                <p>Escribe abajo qué quieres lograr con tu producto y la IA te devuelve un prompt listo para copiar.</p>
            </div>
            <% } else { for (PromptGenerado p : generados) { %>
            <div class="gen-card">
                <div class="gen-meta">
                    <span class="gen-tag"><%= Instrucciones.paraTextarea(p.getObjetivo()) %></span>
                    <span class="gen-idea" title="<%= Instrucciones.paraAtributo(p.getIdea()) %>">📝 <%= p.getIdeaHtml() %></span>
                    <span style="margin-left:auto;">Tokens: <%= p.getTokens() %></span>
                </div>
                <div class="gen-texto"><%= p.getTextoHtml() %></div>
                <div class="gen-actions">
                    <button type="button" onclick="copiarPrompt(this)">📋 Copiar prompt</button>
                    <a class="gen-main" href="ia?cargar=<%= java.net.URLEncoder.encode(p.getTexto(), "UTF-8") %>">💬 Usar en el chat</a>
                    <a href="comparar?pregunta=<%= java.net.URLEncoder.encode(p.getTexto(), "UTF-8") %>">⚖️ Abrir en el comparador</a>
                </div>
            </div>
            <% } } %>
        </div>

        <div class="chat-input-area">
            <div class="input-column">
                <form id="genForm" action="generar" method="post">
                    <div class="gen-obj" style="margin-bottom:8px;">
                        <label for="objetivo">Objetivo del prompt:</label>
                        <select name="objetivo" id="objetivo">
                            <option value="ficha">Ficha técnica del producto</option>
                            <option value="venta">Texto de venta / anuncio</option>
                            <option value="resena">Reseña honesta</option>
                            <option value="guion">Guion para video o reel</option>
                            <option value="seo">Título y descripción para tienda online</option>
                            <option value="comparar">Comparación entre dos productos</option>
                            <option value="libre">Lo que yo escriba (sin objetivo fijo)</option>
                        </select>
                    </div>

                    <div class="input-box-wrapper">
                        <textarea placeholder="Ej: Tengo unos tenis para correr a $280.000 y quiero venderlos por Instagram…" rows="1" id="userInput" name="idea"><%= Instrucciones.paraTextarea(ideaGuardada) %></textarea>

                        <div class="input-watermark">
                            Nexus es una IA y puede cometer errores.
                        </div>

                        <button class="send-btn" type="submit" aria-label="Generar prompt">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="22" y1="2" x2="11" y2="13"></line>
                            <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
                            </svg>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function textoDePrompt(btn) {
            return btn.closest('.gen-card').querySelector('.gen-texto').innerText.trim();
        }

        function copiarPrompt(btn) {
            navigator.clipboard.writeText(textoDePrompt(btn)).then(function () {
                var original = btn.textContent;
                btn.textContent = '✅ Copiado';
                setTimeout(function () { btn.textContent = original; }, 2000);
            });
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
                document.getElementById('genForm').submit();
            }
        });

        // Borrador: la idea que escribas se conserva aunque te vayas al chat
        // o al comparador y vuelvas por el menú.
        var CLAVE_BORRADOR = 'nexus-borrador-prompts';
        if (textarea.value) {
            // Texto que devolvió el servidor (idea conservada tras un error)
            sessionStorage.setItem(CLAVE_BORRADOR, textarea.value);
        } else if (sessionStorage.getItem(CLAVE_BORRADOR)) {
            textarea.value = sessionStorage.getItem(CLAVE_BORRADOR);
        }
        textarea.addEventListener('input', function () {
            sessionStorage.setItem(CLAVE_BORRADOR, this.value);
        });
        document.getElementById('genForm').addEventListener('submit', function () {
            // Tras generar, la caja empieza limpia (si hubo error, el servidor
            // devuelve la idea y este borrador ya no hace falta)
            sessionStorage.removeItem(CLAVE_BORRADOR);
        });
        if (textarea.value) textarea.dispatchEvent(new Event('input'));

        // Al cargar, baja solo hasta el último prompt generado
        var cm = document.getElementById('chatMessages');
        if (cm) { cm.scrollTop = cm.scrollHeight; }
    </script>
</body>
</html>
