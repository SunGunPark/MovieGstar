<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="user.UserDTO" %>
<%@ page import="user.UserDAO" %>
<%@ page import="util.SHA256" %>
<%@ page import="java.io.PrintWriter" %>
<%
	request.setCharacterEncoding("UTF-8");
	String userID = null;
	String userPassword = null;
	if(request.getParameter("userID") != null) {
		userID = request.getParameter("userID");
	}
	if(request.getParameter("userPassword") != null) {
		userPassword = request.getParameter("userPassword");
	}
	if(userID == null || userPassword == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('입력이 안 된 사항이 있습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	}
	UserDAO userDAO = new UserDAO();
	int result = userDAO.delete(userID, userPassword);
	if (result == 0) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('비밀번호가 틀렸습니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else if(result == -1){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('존재하지 않는 아이디입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else if(result == -2){
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('데이터베이스 오류입니다.');");
		script.println("history.back();");
		script.println("</script>");
		script.close();
		return;
	} else {
		session.invalidate();
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('성공적으로 탈퇴하였습니다.');");
		script.println("location.href = 'index.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
%>