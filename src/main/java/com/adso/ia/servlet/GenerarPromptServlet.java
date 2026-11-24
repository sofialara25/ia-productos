package com.adso.ia.servlet;

import com.adso.ia.model.PromptGenerado;
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
import javax.servlet.http.HttpSession;

// GENERADOR: el usuario escribe qué quiere lograr y la IA devuelve un prompt
// listo para copiar. El prompt nace aquí y se puede llevar al chat o al comparador.
@WebServlet("/generar")
public class GenerarPromptServlet extends HttpServlet {

    // Objetivos que ofrece el desplegable (valor = texto que va al modelo)
    private static final String[][] OBJETIVOS = {
        {"ficha", "Ficha técnica del producto"},
        {"venta", "Texto de venta / anuncio"},
        {"resena", "Reseña honesta"},
        {"guion", "Guion para video o reel"},
        {"seo", "Título y descripción para tienda online"},
        {"comparar", "Comparación entre dos productos"},
        {"libre", "Lo que yo escriba (sin objetivo fijo)"}
    };

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, ServletException {

        req.setCharacterEncoding("UTF-8");
        res.setContentType("text/html;charset=UTF-8");

        String idea = req.getParameter("idea");
        String objetivo = req.getParameter("objetivo");
        if (idea == null || idea.isBlank()) {
            req.getSession().setAttribute("errorGen",
                    "Escribe qué quieres lograr antes de generar el prompt.");
            res.sendRedirect("prompts.jsp");
            return;
        }

        // El desplegable envía una clave corta; se traduce al texto completo
        String objetivoTexto = "Lo que yo escriba (sin objetivo fijo)";
        for (String[] o : OBJETIVOS) {
            if (o[0].equals(objetivo)) {
                objetivoTexto = o[1];
                break;
            }
        }

        String user = "Objetivo: " + objetivoTexto + "\n\nLo que quiero lograr: " + idea.trim();

        HttpSession ses = req.getSession();
        try {
            RespuestaIA r = new GroqService().preguntar(Instrucciones.GENERADOR, user);
            List<PromptGenerado> lista =
                    (List<PromptGenerado>) ses.getAttribute("promptsGenerados");
            if (lista == null) {
                lista = new ArrayList<>();
                ses.setAttribute("promptsGenerados", lista);
            }
            lista.add(0, new PromptGenerado(idea.trim(), objetivoTexto,
                    r.getTexto(), r.getTokens()));
            if (lista.size() > 10) lista.remove(lista.size() - 1);

            ses.setAttribute("consultasRestantes", r.getConsultasRestantes());
            ses.setAttribute("limiteConsultas", r.getLimiteConsultas());
            ses.removeAttribute("errorGen");
            ses.removeAttribute("idea"); // éxito: la caja queda vacía

        } catch (GroqException e) {
            ses.setAttribute("errorGen", "Error " + e.getCodigoHttp() + ": " + e.getMessage());
            ses.setAttribute("idea", idea); // error: se conserva para reintentar
        } catch (Exception e) {
            ses.setAttribute("errorGen", "Error inesperado: " + e.getMessage());
            ses.setAttribute("idea", idea);
        }

        // PRG: recargar no vuelve a consumir una consulta
        res.sendRedirect("prompts.jsp");
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        // ?limpiar=1 borra los prompts generados
        if ("1".equals(req.getParameter("limpiar"))) {
            HttpSession ses = req.getSession();
            ses.removeAttribute("promptsGenerados");
            ses.removeAttribute("errorGen");
            ses.removeAttribute("idea");
        }
        res.sendRedirect("prompts.jsp");
    }
}
