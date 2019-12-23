<%@page import="movie.movieArray"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="user.UserDAO" %>
<%@ page import="evaluation.EvaluationDAO" %>
<%@ page import="evaluation.EvaluationDTO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="movie.movieArray" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<title>영화평가 사이트  MovieGstar</title>
	<link rel="stylesheet" href="./css/bootstrap.min.css">
	<link rel="stylesheet" href="./css/custom.css">
</head>
<body>
<%
	request.setCharacterEncoding("UTF-8");
	String MovieDivide = "전체";
	String searchType = "최신순";
	String search = "";
	String movieSearch = "";
	int pageNumber = 0;
	if(request.getParameter("MovieDivide") != null) {
		MovieDivide = request.getParameter("MovieDivide");
	}
	if(request.getParameter("searchType") != null) {
		searchType = request.getParameter("searchType");
	}
	if(request.getParameter("search") != null) {
		search = request.getParameter("search");
	}
	if(request.getParameter("movieSearch") != null) {
		movieSearch = request.getParameter("movieSearch");
	}
	if(request.getParameter("pageNumber") != null) {
		try{
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		} catch (Exception e) {
			System.out.println("검색 페이지 번호 오류");
		}
	}
	String userID = null;
	if(session.getAttribute("userID") != null) {
		userID = (String) session.getAttribute("userID");
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
	<section class="container">
		<form method="get" action="./index.jsp" class="form-inline mt-3">
			<select name="MovieDivide" class="form-control mx-1 mt-2">
				<option value="전체">전체</option>
				<option value="2019" <%if(MovieDivide.equals("2019")) out.println("selected"); %>>2019</option>
				<option value="2018" <%if(MovieDivide.equals("2018")) out.println("selected"); %>>2018</option>
				<option value="2017" <%if(MovieDivide.equals("2017")) out.println("selected"); %>>2017</option>
				<option value="2016" <%if(MovieDivide.equals("2016")) out.println("selected"); %>>2016</option>
				<option value="2015" <%if(MovieDivide.equals("2015")) out.println("selected"); %>>2015</option>
				<option value="2014" <%if(MovieDivide.equals("2014")) out.println("selected"); %>>2014</option>
				<option value="2013" <%if(MovieDivide.equals("2013")) out.println("selected"); %>>2013</option>
				<option value="2012" <%if(MovieDivide.equals("2012")) out.println("selected"); %>>2012</option>
				<option value="2011" <%if(MovieDivide.equals("2011")) out.println("selected"); %>>2011</option>
				<option value="2010" <%if(MovieDivide.equals("2010")) out.println("selected"); %>>2010</option>
			</select>
			<select name="searchType" class="form-control mx-1 mt-2">
				<option value="최신순">최신순</option>
				<option value="추천순" <%if(searchType.equals("추천순")) out.println("selected"); %>>추천순</option>
				<option value="스토리순" <%if(searchType.equals("스토리순")) out.println("selected"); %>>스토리순</option>
				<option value="연기순" <%if(searchType.equals("연기순")) out.println("selected"); %>>연기순</option>
				<option value="CG순" <%if(searchType.equals("CG순")) out.println("selected"); %>>CG순</option>
				<option value="종합별점순" <%if(searchType.equals("종합별점순")) out.println("selected"); %>>종합별점순</option>
			</select>
			<input type="text" name="search" class="form-control mx-1 mt-2" placeholder="내용을 입력하세요.">
			<button type="submit" class="btn btn-primary mx-1 mt-2">검색</button>
			<a class="btn btn-primary mx-1 mt-2" href="evaluationRegister.jsp">등록하기</a>
			<a class="btn btn-danger mx-1 mt-2" data-toggle="modal" href="#reportModal">신고</a>
		</form>
<%
	ArrayList<EvaluationDTO> evaluationList = new ArrayList<EvaluationDTO>();
	evaluationList = new EvaluationDAO().getList(MovieDivide, searchType, search, pageNumber);
	if(evaluationList != null)
		for(int i=0; i< evaluationList.size(); i++) {
			if(i == 5) break;
			EvaluationDTO evaluation = evaluationList.get(i);
%>
<!-- 영화평가 1 -->
	<div class="card bg-light mt-3">
		<div class="card-header bg-light">
			<div class="row">
				<div class="col-8 text-left"><%=evaluation.getMovieName() %>&nbsp;<small><%=evaluation.getUserID()%></small></div>
				<div class="col-4 text-right">
					종합<span style="color: red;"><%=evaluation.getTotalScore()%></span>
				</div>
			</div>
		</div>
		<div class="card-body">
			<h5 class="card-title">
				<%=evaluation.getEvaluationTitle() %>&nbsp;
			</h5>
			<p class="care-text"><%=evaluation.getEvaluationContent()%></p>
			<div class="row">
				<div class="col-9 text-left">
					스토리 <span style="color: red;"><%= evaluation.getStoryScore() %></span>
					연기 <span style="color: red;"><%= evaluation.getActorScore() %></span>
					음악 및 CG <span style="color: red;"><%= evaluation.getTechScore() %></span>
					<span style="color: green;">(추천: <%= evaluation.getLikeCount() %>)</span>
				</div>
				<div class="col-3 text-right">
					<a onclick="return confirm('추천하시겠습니까?')" href="./likeAction.jsp?evaluationID=<%= evaluation.getEvaluationID()%>">추천</a>
					<a onclick="return confirm('삭제하시겠습니까?')" href="./deleteAction.jsp?evaluationID=<%= evaluation.getEvaluationID()%>">삭제</a>
				</div>
			</div>
		</div>
	</div>
<%
		}
%>
	</section>
	<ul class="pagination justify-content-center mt-3">
		<li class="page-item">
<%
	if(pageNumber <= 0) {
%>
	<a class="page-link disabled">이전</a>
<%
	} else {
%>
	<a class="page-link" href="./index.jsp?MovieDivide=<%=URLEncoder.encode(MovieDivide, "UTF-8")%>
	&searchType=<%=URLEncoder.encode(searchType, "UTF-8")%>
	&search=<%=URLEncoder.encode(search, "UTF-8")%>
	&pageNumber=<%=pageNumber -1%>">이전</a>
<%
	}
%>
		</li>
		<li class="page-item">
<%
	if(evaluationList.size() < 6) {
%>
	<a class="page-link disabled">다음</a>
<%
	} else {
%>
	<a class="page-link" href="./index.jsp?MovieDivide=<%=URLEncoder.encode(MovieDivide, "UTF-8")%>
	&searchType=<%=URLEncoder.encode(searchType, "UTF-8")%>
	&search=<%=URLEncoder.encode(search, "UTF-8")%>
	&pageNumber=<%=pageNumber + 1%>">다음</a>
<%
		}
%>
		</li>
	</ul>
<!-- 평가 등록 -->
	<div class="modal fade" id="registerModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">평가 등록</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="./evaluationRegisterAction.jsp" method="post">
						<div class="form-group">
						<a class="btn btn-primary mx-1 mt-2" data-toggle="modal" href="#movieSearchModal">검색</a>
						</div>
						<div class="form-group">
							<label>영화제목</label>
								<select name="movieName" class="form-control">
								</select>
						</div>
						<div class="form-group">
							<label>영화 장르</label>
							<select name="movieDivide" class="form-control">
								<option value="호러">호러</option>
								<option value="코미디">코미디</option>
								<option value="기타">기타</option>
							</select>
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
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-primary">등록하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
<!-- 신고하기 -->
		<div class="modal fade" id="reportModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">신고하기</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form action="./reportAction.jsp" method="post">	
						<div class="form-group">
							<label>신고 제목</label>
							<input type="text" name="reportTitle" class="form-control" maxlength="40">
						</div>
						<div class="form-group">
							<label>신고 내용</label>
							<textarea name="reportContent" class="form-control" maxlength="2048" style="height: 180px;"></textarea>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-danger">신고하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
<!-- 영화검색하기 -->
		<div class="modal fade" id="movieSearchModal" tabindex="-1" role="dialog" aria-labelledby="modal" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="modal">영화검색</h5>
					<button type="button" class="close" data-dismiss="modal" aria-label="close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<form id = "movie_searchForm">	
						<div class="input-group">
							<span class="input-group-addon">영화제목</span>
							<input type="text" class = "form-control" name="query" id="query">
							<span class = "input-group-btn">
								<input type="submit" class="btn btn-warning" value="검색" id="movieSearchbtn">
							</span>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-dismiss="modal">취소</button>
							<button type="submit" class="btn btn-primary">적용하기</button>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<footer class="bg-dark mt-4 p-5 text-center" style="color: #FFFFFF;">
		Copyright &copy; 2019 박성운 All Rights Reserved.
	</footer>
	<script src="./js/jquery.min.js"></script>
	<script src="./js/popper.js"></script>
	<script src="./js/bootstrap.min.js"></script>
</body>
</html>