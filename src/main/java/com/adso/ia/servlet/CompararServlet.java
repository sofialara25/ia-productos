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

@WebServlet("/comparar")
public class CompararServlet extends HttpServlet {

  protected void doPost(HttpServletRequest req, HttpServletResponse res)
      throws IOException, ServletException {
    req.setCharacterEncoding("UTF-8");
    res.setContentType("text/html;charset=UTF-8");

    String lado = req.getParameter("lado");
    boolean izq = !"B".equals(lado);

    String pregunta = req.getParameter(izq ? "preguntaA" : "preguntaB");

    HttpSession ses = req.getSession();

    if (pregunta == null || pregunta.isBlank()) {
      String nombreLado = izq ? "Prompt 1" : "Prompt 2";
      ses.setAttribute("error", "Escribe el contenido de " + nombreLado + " antes de enviar.");
      res.sendRedirect("comparar.jsp");
      return;
    }
    pregunta = pregunta.trim();

    ses.setAttribute(izq ? "preguntaA" : "preguntaB", pregunta);

    try {
      RespuestaIA r = new GroqService().preguntar(Instrucciones.BASE, pregunta);
      ses.setAttribute(izq ? "respuestaA" : "respuestaB", r);
      ses.setAttribute("consultasRestantes", r.getConsultasRestantes());
      ses.setAttribute("limiteConsultas", r.getLimiteConsultas());
      ses.removeAttribute("error");
    } catch (GroqException e) {
      ses.setAttribute("error", e.paraMostrar());
    } catch (Exception e) {
      ses.setAttribute("error", "Error inesperado: " + e.getMessage());
    }

    res.sendRedirect("comparar.jsp");
  }

  protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
    req.setCharacterEncoding("UTF-8");
    HttpSession ses = req.getSession();

    if ("1".equals(req.getParameter("limpiar"))) {
      limpiar(ses);
      res.sendRedirect("comparar.jsp");
      return;
    }

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