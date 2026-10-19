<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
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

    <!-- GALERÍA DE PROMPTS -->
    <div class="chat-container">
        <div class="chat-header">
            <span class="chat-title">
                <svg class="icon" viewBox="0 0 24 24"><path d="M9 18h6"/><path d="M10 22h4"/><path d="M12 2a7 7 0 0 0-4 12.7c.6.5 1 1.2 1 2V17h6v-.3c0-.8.4-1.5 1-2A7 7 0 0 0 12 2z"/></svg>
                Galería de prompts
            </span>
        </div>

        <div class="chat-messages" id="chatMessages" style="align-items:stretch;">
            <style>
                .prompt-grid { display:grid; grid-template-columns:1fr 1fr; gap:12px; width:100%; }
                .p-card { background:var(--bg-card); border:1px solid var(--border-color); border-radius:10px; padding:14px; display:flex; flex-direction:column; gap:8px; }
                .p-card h3 { color:var(--accent-blue); font-size:0.95rem; }
                .p-card p { font-size:0.85rem; white-space:pre-wrap; background:var(--bg-main); border-radius:8px; padding:10px; flex:1; }
                .p-card small.p-hint { font-size:0.75rem; color:var(--text-muted); }
                .p-card button { align-self:flex-end; background:var(--chat-user-bg); color:var(--accent-blue); border:1px solid var(--border-color); border-radius:20px; padding:5px 14px; cursor:pointer; font-size:0.8rem; }
                .p-card button:hover { background:var(--accent-blue); color:#fff; }
                @media (max-width: 700px) { .prompt-grid { grid-template-columns:1fr; } }
            </style>
            <p style="color:var(--text-muted);font-size:0.9rem;">Todo gira alrededor de <b>productos</b>. Copia uno, pégalo en el chat y envíalo. 📦 trae datos, 🧠 la IA responde de memoria, ⚖️ pareja del mismo producto con distinta instrucción: llévala al Comparador. El 1↔2 y el 3↔4 son el mismo producto pidiendo cosas distintas.</p>
            <div class="prompt-grid">
<div class="p-card"><h3>1. 📦⚖️ Tenis: descríbelo</h3><p>Producto: Tenis deportivos
Precio: $280.000
Suela antideslizante, tallas 38 a 44.
Descríbelo en 2 frases, sin adornos.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>2. 📦⚖️ Mismo tenis: véndelo</h3><p>Producto: Tenis deportivos
Precio: $280.000
Suela antideslizante, tallas 38 a 44.
Véndemelo en 2 frases que den ganas de comprarlo.</p><small class="p-hint">Mismos datos que el 1: compara las respuestas.</small><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>3. 📦⚖️ Café: ficha técnica</h3><p>Producto: Café orgánico 500g
Precio: $32.000
Origen Huila, tueste medio.
Haz una ficha técnica ordenada.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>4. 📦⚖️ Mismo café: post</h3><p>Producto: Café orgánico 500g
Precio: $32.000
Origen Huila, tueste medio.
Escríbeme un post corto para Instagram con 3 hashtags.</p><small class="p-hint">Mismos datos que el 3: compara las respuestas.</small><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>5. 📦 Audífonos: pros y contras</h3><p>Producto: Audífonos inalámbricos
Precio: $150.000
Batería 20 horas, Bluetooth 5.3.
Dame una reseña honesta con pros y contras.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>6. 📦 Jabón: texto SEO</h3><p>Producto: Jabón artesanal de avena
Precio: $12.000
Piel sensible, 100g.
Escribe título SEO y descripción con palabras clave.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>7. 📦 Gorra: post Instagram</h3><p>Producto: Gorra bordada
Precio: $45.000
Talla única ajustable.
Escríbeme un post corto para Instagram con 3 hashtags.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>8. 📦 Anchetas: mensaje WhatsApp</h3><p>Producto: Anchetas de cumpleaños
Precio: $75.000
Incluye tarjeta personalizada.
Escríbelo en 1 frase para vender por WhatsApp.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>9. 📦 Aretes: ideas de fotos</h3><p>Producto: Aretes de plata
Precio: $55.000
Dame 5 ideas de fotos para publicarlos en redes.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>10. 📦 Mermelada: nombre de marca</h3><p>Producto: Mermelada de mora hecha en casa
Precio: $15.000 frasco.
Dame 5 ideas de nombre para la marca.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>11. 📦 Panadería: eslóganes</h3><p>Producto: Panadería de barrio
Pan fresco desde las 5am.
Dame 3 eslóganes cortos.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>12. 📦 Curso: responder "está caro"</h3><p>Producto: Curso de repostería
Precio: $120.000, 4 clases.
Un cliente dice "está muy caro". Dame una respuesta amable que lo convenza.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>13. 📦 Combo: shampoo + acondicionador</h3><p>Producto A: Shampoo sólido $25.000.
Producto B: Acondicionador sólido $28.000.
Arma una oferta combo con precio y texto de venta.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>14. 📦 Velas: precio desde el costo</h3><p>Producto: Velas aromáticas
Me cuesta hacerlo: $18.000
Quiero ganar el 40%.
¿A cuánto lo vendo y por qué?</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>15. 📦 Termo: correo lanzamiento</h3><p>Producto: Termo acero 750ml
Precio: $60.000
Frío 24h, calor 12h.
Redacta un correo corto anunciando su lanzamiento.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>16. 🧠 Avon: famoso y top ventas</h3><p>¿Cuál es el producto más famoso de Avon y cuál es su top 1 en ventas?
Descríbelos y dime hasta qué año llega tu información.</p><small class="p-hint">Sin datos: la IA responde de memoria.</small><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>17. 🧠 Historia de Nokia</h3><p>Cuéntame la historia de la marca Nokia en 5 líneas:
auge, caída y en qué anda hoy.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>18. 🧠 Duelo Coca vs Pepsi</h3><p>Compara Coca-Cola y Pepsi en 3 líneas:
sabor, precio y cuál prefieren los jóvenes.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>19. 🧠 La ruana boyacense</h3><p>Explica qué es una ruana, de qué está hecha
y para qué sirve, en 3 líneas.</p><button onclick="copiar(this)">📋 Copiar</button></div>

<div class="p-card"><h3>20. ⚖️ Para el Comparador</h3><p>Producto: Reloj inteligente
Precio: $199.000
Monitor de sueño y ritmo cardíaco. Descríbelo.</p><small class="p-hint">Cópialo y llévalo al Comparador: Técnico vs Publicitario.</small><button onclick="copiar(this)">📋 Copiar</button></div>
            </div>
        </div>
    </div>

    <!-- JAVASCRIPT -->
    <script>
        function copiar(btn) {
            var t = btn.parentElement.querySelector('p').innerText;
            navigator.clipboard.writeText(t).then(function() {
                btn.textContent = '✅ ¡Copiado! Pégalo en el chat';
                setTimeout(function(){ btn.textContent = '📋 Copiar'; }, 2000);
            });
        }

        // Tema claro/oscuro: guarda tu elección en el navegador
        // (los íconos de luna/sol se alternan por CSS con la clase "dark")
        function toggleTheme() {
            var dark = !document.body.classList.contains('dark');
            document.body.classList.toggle('dark', dark);
            localStorage.setItem('nexus-theme', dark ? 'dark' : 'light');
        }
        (function() {
            if (localStorage.getItem('nexus-theme') === 'dark') {
                document.body.classList.add('dark');
            }
        })();
    </script>
</body>
</html>
