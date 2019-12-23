<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="movie.movieArray" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title>영화평가 사이트  MovieGstar</title>
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<link rel="stylesheet" href="./css/custom.css">
</head>
<script>
	function evaluationHide() {
		var evaluationRegister = document.getElementById("evaluationRegister");
		evaluationRegister.style="display:none";
	}
	function movieClickEvent(mvObj) {
		var selected = mvObj.id;
		var pub = mvObj.childNodes[9];
		var movieName = document.getElementById("movieName");
		var movieDivide = document.getElementById("movieDivide");
		var movieSearchTable = document.getElementById("movieSearchTable");
		var evaluationRegister = document.getElementById("evaluationRegister");
		movieSearchTable.innerHTML = "";
		movieName.value = selected;
		movieDivide.value = pub.innerHTML;
		evaluationRegister.style="display:block";
}
</script>
<body>
<%
	request.setCharacterEncoding("UTF-8");
	String userID = null;
	String search = "";
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
	}
	if(request.getParameter("search") != null) {
		search = request.getParameter("search");
	}
	if(userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인이 필요합니다.');");
		script.println("location.href = 'userlogin.jsp';");
		script.println("</script>");
		script.close();
		return;
	}
%>
	<nav class="navbar navbar-expand-lg navbar-light bg-light">
		<a class="navbar-brand" href="index.jsp">MovieGstar</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div id="navbar" class="collapse navbar-collapse">
			<ul class="navbar-nav mr-auto">
				<li class="nav-item active">
					<a class="nav-link" href="index.jsp">
						메인
					</a>
				</li>
				<li class="nav-item dropdown">
					<a class="nav-link dropdown-toggle" id="dropdown" data-toggle="dropdown">
						회원관리
					</a>
					<div class="dropdown-menu" aria-labelledby="dropdown">
<%
	if((String) session.getAttribute("userID") == null) {
%>
						<a class="dropdown-item" href="userlogin.jsp">로그인</a>
						<a class="dropdown-item" href="userjoin.jsp">회원가입</a>
<%
	} else {
%>
						<a class="dropdown-item" href="userlogout.jsp">로그아웃</a>
						<a class="dropdown-item" href="userdelete.jsp">회원탈퇴</a>
<%
	}
%>
					</div>
			</ul>
			<form action="./index.jsp" method="get" class="form-inline my-2 my-lg-0">
				<input type="text" name="search" class="form-control mr-sm-2" type="search" placeholder="내용을 입력하세요." aria-label="Search">
				<button class="btn btn-outline-success my-2 my-sm-0" type="submit">검색</button> 
			</form>
		</div>
	</nav>
	<br>
	<section class="container">
	<h5>영화 검색</h5>
	<form action="./evaluationRegister.jsp" method="get" class="form-inline my-2 my-lg-0">
	<input type="text" name="search" class="form-control mr-sm-2" type="search" placeholder="내용을 입력하세요." aria-label="Search">
	<button class="btn btn-outline-success my-2 my-sm-0" type="submit" onclick="javascript:evaluationHide()">검색</button> 
	</form>
	<br>
		<div id="movieSearchTable">
		<table class="table table-hover">
		<th>영화제목</th>
		<th>감독</th>
		<th>배우</th>
		<th>이미지</th>
		<th>제작년도</th>
<%
	movieArray mrr = new movieArray();
	JSONArray item = mrr.movieSearch(search);
	try{
		for(int i=0;i<item.size();i++) {
			JSONObject tmp = (JSONObject)item.get(i);
			String title = (String)tmp.get("title");
			String director = (String)tmp.get("director");
			String image = (String)tmp.get("image");
			String actor = (String)tmp.get("actor");
			String link = (String)tmp.get("link");
			String subtitle = (String)tmp.get("subtitle");
			String pubDate = (String)tmp.get("pubDate");
%>
		<tr id="<%=title.replace("<b>", "").replace("</b>", "")%>" onclick="javascript:movieClickEvent(this)">
			<td><%=title%></td>
			<td><%=director%></td>
			<td><%=actor%></td>
			<td><img src="<%=image%>"></td>
			<td><%=pubDate%></td>
		</tr>
<%
		}
	} catch(Exception e) {
		e.printStackTrace();
	}
%>
		</table>
		</div>
		
	<form action="./evaluationRegisterAction.jsp" method="post" id= "evaluationRegister" style="display:none">
		<div class="form-group">
			<label>영화제목</label>
			<input name="movieName" class="form-control" id="movieName" type="text" readonly>
		</div>
		<div class="form-group">
			<label>제작년도</label>
			<input name="movieDivide" class="form-control" id="movieDivide" type="text" readonly>
		</div>
		<div class="form-group">
			<label>제목</label>
			<input type="text" name="evaluationTitle" class="form-control" maxlength="40">
		</div>
		<div class="form-group">
			<label>내용</label>
			<textarea name="evaluationContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
		</div>
		<div class="form-row">
			<div class="form-group col-sm-3">
				<label>스토리</label>
				<select name="storyScore" class="form-control">
					<option  value="1" selected>☆☆☆☆</option>
					<option  value="2">☆☆☆★</option>
					<option  value="3">☆☆★★</option>
					<option  value="4">☆★★★</option>
					<option  value="5">★★★★</option>
				</select>
			</div>
			<div class="form-group col-sm-3">
				<label>배우 연기</label>
				<select name="actorScore" class="form-control">
					<option  value="1" selected>☆☆☆☆</option>
					<option  value="2">☆☆☆★</option>
					<option  value="3">☆☆★★</option>
					<option  value="4">☆★★★</option>
					<option  value="5">★★★★</option>
				</select>
			</div>
			<div class="form-group col-sm-3">
				<label>음악 및 CG</label>
				<select name="techScore" class="form-control">
					<option  value="1" selected>☆☆☆☆</option>
					<option  value="2">☆☆☆★</option>
					<option  value="3">☆☆★★</option>
					<option  value="4">☆★★★</option>
					<option  value="5">★★★★</option>
				</select>
			</div>
			<div class="form-group col-sm-3">
				<label>통합</label>
				<select name="totalScore" class="form-control">
					<option  value="1" selected>☆☆☆☆</option>
					<option  value="2">☆☆☆★</option>
					<option  value="3">☆☆★★</option>
					<option  value="4">☆★★★</option>
					<option  value="5">★★★★</option>
				</select>
			</div>
			<div class="form-group col-sm-3">
				<a href="./index.jsp" type="button" class="btn btn-secondary">취소</a>
				<button type="submit" class="btn btn-primary">등록하기</button>
			</div>
		</div>
	</form>
	</section>
	<footer class="bg-dark mt-4 p-5 text-center" style="color: #FFFFFF;">
		Copyright &copy; 2019 박성운 All Rights Reserved.
	</footer>
	<script src="./js/jquery.min.js"></script>
	<script src="./js/popper.js"></script>
	<script src="./js/bootstrap.min.js"></script>
</body>
</html>