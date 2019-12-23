<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="evaluation.EvaluationDTO" %>
<%@ page import="evaluation.EvaluationDAO" %>
<%@ page import="util.SHA256" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	String userID = null;
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if(userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.');");
		script.println("location.href = 'userlogin.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
	
	
	String movieName = null;
	String movieDivide = null;
	String evaluationTitle = null;
	String evaluationContent = null;
	String storyScore = null;
	String actorScore = null;
	String techScore = null;
	String totalScore = null;
	
	
	String userPassword = null;
	String userEmail = null;
	if(request.getParameter("userID") != null) {
		userID = request.getParameter("userID");
	}
	if(request.getParameter("movieName") != null) {
		movieName = request.getParameter("movieName");
	}
	if(request.getParameter("movieDivide") != null) {
		movieDivide = request.getParameter("movieDivide");
	}
	if(request.getParameter("evaluationTitle") != null) {
		evaluationTitle = request.getParameter("evaluationTitle");
	}
	if(request.getParameter("evaluationContent") != null) {
		evaluationContent = request.getParameter("evaluationContent");
	}
	if(request.getParameter("storyScore") != null) {
		storyScore = request.getParameter("storyScore");
	}
	if(request.getParameter("actorScore") != null) {
		actorScore = request.getParameter("actorScore");
	}
	if(request.getParameter("techScore") != null) {
		techScore = request.getParameter("techScore");
	}
	if(request.getParameter("totalScore") != null) {
		totalScore = request.getParameter("totalScore");
	}
/*
	if(request.getParameter("int형") != null) {
		try{
			int형 = Integer.parseInt(request.getParameter("Int형"));
		} catch (Exception e) {
			System.out.println("Int형 자료 데이터 오류");
		}
	}
*/
	if( userID == null || movieName == null || movieDivide == null ||
		evaluationTitle == null || evaluationContent == null ||
		storyScore == null || actorScore == null || techScore == null ||
		totalScore == null || evaluationTitle.equals("") || 
		evaluationContent.equals("")) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	EvaluationDAO evaluationDAO = new EvaluationDAO();
	int result = evaluationDAO.write(new EvaluationDTO(0, userID, movieName, 
										 movieDivide,evaluationTitle, evaluationContent, 
										 storyScore, actorScore, techScore, totalScore, 0));
	
	if (result == -1) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('게시글 등록에 실패했습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("location.href = 'index.jsp'");
		script.println("</script>");
		script.close();
		return;
	}
%>