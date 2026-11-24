package com.adso.ia.servlet;

import com.adso.ia.model.MensajeChat;
import com.adso.ia.model.RespuestaIA;
import com.adso.ia.service.GroqException;
import com.adso.ia.service.GroqService;
import com.adso.ia.util.Instrucciones;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/ia")
public class IAServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        String pregunta = req.getParameter("pregunta");
        if (pregunta == null || pregunta.isBlank()) {
            req.getSession().setAttribute("error", "Escribe algo antes de enviar.");
            res.sendRedirect("index.jsp");
            return;
        }
        pregunta = pregunta.trim();

        RespuestaIA r = null;
        String error = null;
        try {
            // Una sola orden para toda la app (Instrucciones.BASE)
            r = new GroqService().preguntar(Instrucciones.BASE, pregunta);
            // Consultas restantes reales (dato oficial de Groq)
            req.getSession().setAttribute("consultasRestantes", r.getConsultasRestantes());
            req.getSession().setAttribute("limiteConsultas", r.getLimiteConsultas());

        } catch (GroqException e) {
            error = "Error " + e.getCodigoHttp() + ": " + e.getMessage();

        } catch (Exception e) {
            error = "Error inesperado: " + e.getMessage();
        }

        // Historial en la sesión: cada envío se suma a la lista (máximo 20)
        List<MensajeChat> historial =
                (List<MensajeChat>) req.getSession().getAttribute("historial");
        if (historial == null) {
            historial = new ArrayList<>();
            req.getSession().setAttribute("historial", historial);
        }
        historial.add(new MensajeChat(pregunta, r, error));
        if (historial.size() > 20) historial.remove(0);

        // PRG: redirigir en vez de reenviar. Así recargar NO repite la consulta.
        res.sendRedirect("index.jsp");
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        // ?limpiar=1 borra el historial y empieza un chat nuevo de verdad
        if ("1".equals(req.getParameter("limpiar"))) {
            req.getSession().removeAttribute("historial");
        }
        // ?cargar=... trae un prompt generado desde el Generador y lo deja
        // en la caja de texto para que solo falte escribir el producto.
        String cargar = req.getParameter("cargar");
        if (cargar != null && !cargar.isBlank()) {
            req.getSession().setAttribute("preguntaChat", cargar);
        }
        res.sendRedirect("index.jsp");
    }
}
