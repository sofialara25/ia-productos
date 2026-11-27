<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,com.adso.ia.model.MensajeChat" %>
<%@ page import="com.adso.ia.util.Instrucciones" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Nexus</title>
        <link rel="stylesheet" href="nexus.css">
    </head>
    <body>
        <% pageContext.setAttribute("paginaActiva", "libre"); %>
        <%@ include file="sidebar.jspf" %>

    <div class="chat-container">
        <div class="chat-header">
            <span class="chat-title">
                <svg class="icon" viewBox="0 0 24 24"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"/></svg>
                Pregunta libre
            </span>
            <div style="margin-left:auto;display:flex;flex-direction:column;align-items:flex-end;gap:2px;">
            <a href="ia?limpiar=1" title="Borrar el historial y empezar de cero" style="background:var(--bg-card);border:1px solid var(--border-color);border-radius:20px;padding:5px 14px;font-size:0.8rem;color:var(--accent-blue);text-decoration:none;">Limpiar</a>
            </div>
        </div>

        <div class="chat-messages" id="chatMessages">
            <%
                Object errChat = request.getAttribute("error");
                if (errChat == null) errChat = session.getAttribute("error");
                if (errChat != null) session.removeAttribute("error");
            %>
            <% if (errChat != null) { %>
            <p style="width:100%;color:#fff;background:#C0392B;border-radius:8px;padding:10px 14px;font-size:0.85rem;"><%= Instrucciones.paraTextarea(String.valueOf(errChat)) %></p>
            <% } %>
            <% List<MensajeChat> historial = (List<MensajeChat>) session.getAttribute("historial");
               if (historial == null || historial.isEmpty()) { %>
            <div class="welcome-screen" id="welcomeScreen">
                <div class="welcome-icon">
                    <svg class="icon" viewBox="0 0 24 24"><path d="M12 2L2 7l10 5 10-5-10-5z"/><path d="M2 17l10 5 10-5"/><path d="M2 12l10 5 10-5"/></svg>
                </div>
                <h2>¡Hola!</h2>
                <p>Escribe abajo los datos de tu producto y lo que necesites: descripción, reseña o ideas de venta.</p>
            </div>
            <% } else { for (int mi = 0; mi < historial.size(); mi++) { MensajeChat m = historial.get(mi); %>
            <div class="message-wrapper user" id="msg-<%= mi %>">
                <div class="message-bubble"><%= m.getPreguntaHtml() %></div>
            </div>
            <% if (m.isError()) { %>
            <div class="message-wrapper ai">
                <div class="message-bubble" style="background:#C0392B;color:#fff;border:none;"><%= m.getErrorHtml() %></div>
            </div>
            <% } else { %>
            <div class="message-wrapper ai">
                <div class="message-bubble"><%= m.getRespuesta().getTextoHtml() %>
                    <small style="color:#7893A6;">Tokens: <%= m.getRespuesta().getTokens() %></small></div>
            </div>
            <% } } } %>
        </div>

        <div class="chat-input-area">
            <div class="input-column">

                <div class="input-box-wrapper">
                    <form id="iaForm" action="ia" method="post">
                        <%
                            String preguntaCarga = (String) session.getAttribute("preguntaChat");
                            if (preguntaCarga == null) preguntaCarga = "";
                            else session.removeAttribute("preguntaChat");
                        %>
                        <textarea placeholder="Ej: Tenis X-Run Pro $280.000, suela de caucho. Hazme la ficha técnica." rows="1" id="userInput" name="pregunta"><%= Instrucciones.paraTextarea(preguntaCarga) %></textarea>

                    <div class="input-watermark">
                        Nexus es una IA y puede cometer errores.
                    </div>

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
    </div>

    <script>
        var CLAVE_BORRADOR = 'nexus-borrador-index';

        function sendMessage() {
            sessionStorage.removeItem(CLAVE_BORRADOR);
            document.getElementById('iaForm').submit();
        }

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

        if (textarea.value) {
            sessionStorage.setItem(CLAVE_BORRADOR, textarea.value);
        } else if (sessionStorage.getItem(CLAVE_BORRADOR)) {
            textarea.value = sessionStorage.getItem(CLAVE_BORRADOR);
        }
        textarea.addEventListener('input', function () {
            sessionStorage.setItem(CLAVE_BORRADOR, this.value);
        });
        document.getElementById('iaForm').addEventListener('submit', function () {
            sessionStorage.removeItem(CLAVE_BORRADOR);
        });
        if (textarea.value) textarea.dispatchEvent(new Event('input'));

        var cm = document.getElementById('chatMessages');
        if (cm) { cm.scrollTop = cm.scrollHeight; }
    </script>
</body>
</html>