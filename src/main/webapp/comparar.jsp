<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.adso.ia.model.RespuestaIA,com.adso.ia.util.Instrucciones" %>
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

        <%
            Object err = request.getAttribute("error");
            if (err == null) err = session.getAttribute("error");
            if (err != null) session.removeAttribute("error");

            String pregA = (String) session.getAttribute("preguntaA");
            if (pregA == null) pregA = "";
            String pregB = (String) session.getAttribute("preguntaB");
            if (pregB == null) pregB = "";

            String pruebaA = Instrucciones.paraAtributo(Instrucciones.PROMPT_PRUEBA_1);
            String pruebaB = Instrucciones.paraAtributo(Instrucciones.PROMPT_PRUEBA_2);

            RespuestaIA rA = (RespuestaIA) request.getAttribute("respuestaA");
            if (rA == null) rA = (RespuestaIA) session.getAttribute("respuestaA");
            RespuestaIA rB = (RespuestaIA) request.getAttribute("respuestaB");
            if (rB == null) rB = (RespuestaIA) session.getAttribute("respuestaB");

            String escPregA = Instrucciones.paraTextarea(pregA);
            String escPregB = Instrucciones.paraTextarea(pregB);
        %>
        <%@ include file="sidebar.jspf" %>

    <div class="chat-container">
        <div class="chat-header">
            <span class="chat-title">
                <svg class="icon" viewBox="0 0 24 24"><path d="M16 3h5v5"/><path d="M21 3l-7 7"/><path d="M8 21H3v-5"/><path d="M3 21l7-7"/><path d="M21 16v5h-5"/><path d="M3 8V3h5"/></svg>
                Comparador
            </span>
            <div style="margin-left:auto;display:flex;flex-direction:column;align-items:flex-end;gap:2px;">
            <a href="comparar?limpiar=1" title="Limpiar los paneles y empezar de cero" style="background:var(--bg-card);border:1px solid var(--border-color);border-radius:20px;padding:5px 14px;font-size:0.8rem;color:var(--accent-blue);text-decoration:none;">Limpiar</a>
            </div>
        </div>

        <div class="chat-messages" id="chatMessages">
            <style>
                .cmp-wrap { display:flex; gap:12px; width:100%; flex:1; align-items:stretch; min-height:44vh; }
                .cmp-panel { flex:1; display:flex; flex-direction:column; gap:8px; background:var(--bg-card); border:1px solid var(--border-color); border-radius:10px; padding:12px; overflow-y:auto; min-height:320px; }
                .cmp-panel h4 { color:var(--accent-blue); font-size:0.9rem; }
                .cmp-panel small { color:var(--text-muted); font-size:0.75rem; }
                .cmp-panel-head { display:flex; align-items:center; justify-content:space-between; gap:8px; }
                .cmp-side { font-size:0.78rem; font-weight:600; text-transform:uppercase; letter-spacing:0.6px; color:var(--text-muted); }
                .cmp-label { font-size:0.72rem; font-weight:600; text-transform:uppercase; letter-spacing:0.5px; color:var(--accent-blue); }
                .cmp-preg { width:100%; resize:vertical; font-size:0.82rem; line-height:1.5; color:var(--text-main); background:var(--bg-main); border:1px solid var(--border-color); border-radius:8px; padding:9px 10px; outline:none; font-family:inherit; min-height:76px; }
                .cmp-preg:focus { border-color:#8FB6D0; box-shadow:0 0 0 3px rgba(63,111,143,0.12); }
                .cmp-send { display:flex; justify-content:flex-end; }
                .cmp-send button { background:var(--accent-blue); color:#fff; border:none; border-radius:20px; padding:7px 17px; font-size:0.8rem; font-weight:600; cursor:pointer; font-family:inherit; }
                .cmp-send button:hover { background:var(--accent-blue-hover); }
                .cmp-resp { font-size:0.9rem; line-height:1.6; white-space:normal; }
                @media (max-width: 700px) { .cmp-wrap { flex-direction:column; } }
            </style>

            <% if (err != null) { %>
            <p style="width:100%;color:#fff;background:#C0392B;border-radius:8px;padding:10px 14px;font-size:0.85rem;"><%= Instrucciones.paraTextarea(String.valueOf(err)) %></p>
            <% } %>

            <div class="cmp-wrap">
                <form class="cmp-panel" id="panelA" action="comparar" method="post">
                    <input type="hidden" name="lado" value="A">
                    <div class="cmp-panel-head">
                        <span class="cmp-side">Prompt 1</span>
                    </div>
                    <textarea id="preguntaA" name="preguntaA" class="cmp-preg" rows="4" aria-label="Prompt 1" data-prueba="<%= pruebaA %>" placeholder="Escribe aquí tu Prompt 1…"><%= escPregA %></textarea>
                    <div class="cmp-send"><button type="submit">▶ Enviar Prompt 1</button></div>
                    <% if (rA != null) { %>
                    <h4>Respuesta</h4>
                    <p class="cmp-resp"><%= rA.getTextoHtml() %></p>
                    <small>Tokens: <%= rA.getTokens() %></small>
                    <% } %>
                </form>

                <form class="cmp-panel" id="panelB" action="comparar" method="post">
                    <input type="hidden" name="lado" value="B">
                    <div class="cmp-panel-head">
                        <span class="cmp-side">Prompt 2</span>
                    </div>
                    <textarea id="preguntaB" name="preguntaB" class="cmp-preg" rows="4" aria-label="Prompt 2" data-prueba="<%= pruebaB %>" placeholder="Escribe aquí tu Prompt 2…"><%= escPregB %></textarea>
                    <div class="cmp-send"><button type="submit">▶ Enviar Prompt 2</button></div>
                    <% if (rB != null) { %>
                    <h4>Respuesta</h4>
                    <p class="cmp-resp"><%= rB.getTextoHtml() %></p>
                    <small>Tokens: <%= rB.getTokens() %></small>
                    <% } %>
                </form>
            </div>
        </div>
    </div>

    <script>
        function redimensionar(ta) {
            ta.style.height = 'auto';
            ta.style.height = Math.min(ta.scrollHeight, 440) + 'px';
        }

        ['preguntaA', 'preguntaB'].forEach(function (id) {
            var ta = document.getElementById(id);
            ta.addEventListener('input', function () { redimensionar(this); });
            redimensionar(ta);
        });

        var clavesBorrador = { preguntaA: 'nexus-borrador-cmpA', preguntaB: 'nexus-borrador-cmpB' };
        Object.keys(clavesBorrador).forEach(function (id) {
            var ta = document.getElementById(id);
            var clave = clavesBorrador[id];
            if (ta.value) {
                sessionStorage.setItem(clave, ta.value);
            } else if (sessionStorage.getItem(clave)) {
                ta.value = sessionStorage.getItem(clave);
                redimensionar(ta);
            } else if (ta.dataset.prueba) {
                ta.value = ta.dataset.prueba;
                redimensionar(ta);
            }
            ta.addEventListener('input', function () {
                sessionStorage.setItem(clave, this.value);
            });
            ta.form.addEventListener('submit', function () {
                sessionStorage.removeItem(clave);
            });
        });

        var lnkLimpiar = document.querySelector('a[href*="limpiar"]');
        if (lnkLimpiar) {
            lnkLimpiar.addEventListener('click', function () {
                sessionStorage.removeItem(clavesBorrador.preguntaA);
                sessionStorage.removeItem(clavesBorrador.preguntaB);
            });
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

        var cm = document.getElementById('chatMessages');
        if (cm) { cm.scrollTop = cm.scrollHeight; }
    </script>
</body>
</html>