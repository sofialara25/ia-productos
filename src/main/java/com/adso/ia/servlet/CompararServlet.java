package com.adso.ia.servlet;

import com.adso.ia.model.RespuestaIA;
import com.adso.ia.service.GroqException;
import com.adso.ia.service.GroqService;
import com.adso.ia.util.Instrucciones;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

// COMPARADOR: cada panel es independiente. El usuario escribe el prompt de su
// lado y pulsa enviar: solo se consulta a Groq ese lado, con la misma orden base.
@WebServlet("/comparar")
public class CompararServlet extends HttpServlet {

  protected void doPost(HttpServletRequest req, HttpServletResponse res)
      throws IOException, ServletException {
    req.setCharacterEncoding("UTF-8");
    res.setContentType("text/html;charset=UTF-8");

    // Qué panel se envió: "A" (izquierda) o "B" (derecha)
    String lado = req.getParameter("lado");
    boolean izq = !"B".equals(lado);

    String pregunta = req.getParameter(izq ? "preguntaA" : "preguntaB");

    HttpSession ses = req.getSession();

    // Sin prompt no se gasta consulta: se avisa y se deja todo como estaba
    if (pregunta == null || pregunta.isBlank()) {
      ses.setAttribute("error", "Escribe el prompt de este lado antes de enviar.");
      res.sendRedirect("comparar.jsp");
      return;
    }
    pregunta = pregunta.trim();

    // El texto se conserva en la caja para poder editarlo y reenviar
    ses.setAttribute(izq ? "preguntaA" : "preguntaB", pregunta);

    try {
      RespuestaIA r = new GroqService().preguntar(Instrucciones.BASE, pregunta);
      ses.setAttribute(izq ? "respuestaA" : "respuestaB", r);
      // Consultas restantes reales (dato oficial de Groq)
      ses.setAttribute("consultasRestantes", r.getConsultasRestantes());
      ses.setAttribute("limiteConsultas", r.getLimiteConsultas());
      ses.removeAttribute("error");
    } catch (GroqException e) {
      ses.setAttribute("error", "Error " + e.getCodigoHttp() + ": " + e.getMessage());
    } catch (Exception e) {
      ses.setAttribute("error", "Error inesperado: " + e.getMessage());
    }

    // PRG: redirigir en vez de reenviar. Así recargar NO repite la consulta.
    res.sendRedirect("comparar.jsp");
  }

  protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
    req.setCharacterEncoding("UTF-8");
    HttpSession ses = req.getSession();

    // ?limpiar=1 borra los dos paneles y empieza de cero
    if ("1".equals(req.getParameter("limpiar"))) {
      limpiar(ses);
      res.sendRedirect("comparar.jsp");
      return;
    }

    // El Generador llega por aquí: el prompt se deja escrito en los dos lados
    String pregunta = req.getParameter("pregunta");
    if (pregunta != null && !pregunta.isBlank()) {
      ses.setAttribute("preguntaA", pregunta);
      ses.setAttribute("preguntaB", pregunta);
      ses.removeAttribute("respuestaA");
      ses.removeAttribute("respuestaB");
      ses.removeAttribute("error");
    }
    res.sendRedirect("comparar.jsp");
  }

  private void limpiar(HttpSession ses) {
    ses.removeAttribute("respuestaA");
    ses.removeAttribute("respuestaB");
    ses.removeAttribute("preguntaA");
    ses.removeAttribute("preguntaB");
    ses.removeAttribute("error");
  }
}
