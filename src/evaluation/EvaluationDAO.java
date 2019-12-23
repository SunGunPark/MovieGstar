package evaluation;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import util.DatabaseUtil;

public class EvaluationDAO {
	
	//글 작성
	public int write(EvaluationDTO evaluationDTO) {
		String SQL = "INSERT INTO EVALUATION VALUES (NULL, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0)";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, evaluationDTO.getUserID().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(2, evaluationDTO.getMovieName().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(3, evaluationDTO.getMovieDivide().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(4, evaluationDTO.getEvaluationTitle().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(5, evaluationDTO.getEvaluationContent().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(6, evaluationDTO.getStoryScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(7, evaluationDTO.getActorScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(8, evaluationDTO.getTechScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			pstmt.setString(9, evaluationDTO.getTotalScore().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\r\n", "<br>"));
			return pstmt.executeUpdate(); //데이터 업데이트
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
			try { if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
		}
		return -1;
	}
	
	public ArrayList<EvaluationDTO> getList(String MovieDivide, String searchType, String search, int pageNumber) {
		if(MovieDivide.equals("전체")) {
			MovieDivide = "";
		}
		ArrayList<EvaluationDTO> evaluationList = null;
		String SQL = "";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			if(searchType.equals("최신순")) {
				SQL = "SELECT * FROM EVALUATION WHERE MovieDivide LIKE ? AND CONCAT(movieName, userID, evaluationTitle, evaluationContent) LIKE"
						+ "? ORDER BY evaluationID DESC LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("추천순")) {
				SQL = "SELECT * FROM EVALUATION WHERE MovieDivide LIKE ? AND CONCAT(movieName, userID, evaluationTitle, evaluationContent) LIKE"
						+ "? ORDER BY likeCount DESC LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("스토리순")) {
				SQL = "SELECT * FROM EVALUATION WHERE MovieDivide LIKE ? AND CONCAT(movieName, userID, evaluationTitle, evaluationContent) LIKE"
						+ "? ORDER BY CAST(storyScore AS INT) DESC LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("연기순")) {
				SQL = "SELECT * FROM EVALUATION WHERE MovieDivide LIKE ? AND CONCAT(movieName, userID, evaluationTitle, evaluationContent) LIKE"
						+ "? ORDER BY CAST(actorScore AS INT) DESC LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("CG순")) {
				SQL = "SELECT * FROM EVALUATION WHERE MovieDivide LIKE ? AND CONCAT(movieName, userID, evaluationTitle, evaluationContent) LIKE"
						+ "? ORDER BY CAST(techScore AS INT) DESC LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;
			} else if (searchType.equals("종합별점순")) {
				SQL = "SELECT * FROM EVALUATION WHERE MovieDivide LIKE ? AND CONCAT(movieName, userID, evaluationTitle, evaluationContent) LIKE"
						+ "? ORDER BY CAST(totalScore AS INT) DESC LIMIT " + pageNumber * 5 + ", " + pageNumber * 5 + 6;
			}
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, "%" + MovieDivide + "%");
			pstmt.setString(2, "%" + search + "%");
			rs = pstmt.executeQuery(); //데이터 조회
			evaluationList = new ArrayList<EvaluationDTO>();
			while(rs.next()) {
				EvaluationDTO evaluation = new EvaluationDTO(
						rs.getInt(1),
						rs.getString(2),
						rs.getString(3),
						rs.getString(4),
						rs.getString(5),
						rs.getString(6),
						rs.getString(7),
						rs.getString(8),
						rs.getString(9),
						rs.getString(10),
						rs.getInt(11)
						);
				evaluationList.add(evaluation);
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
			try { if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
		}
		return evaluationList;
	}
//추천
	public int like(String evaluationID) {
		String SQL = "UPDATE EVALUATION SET likeCount = likeCount + 1 WHERE evaluationID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(evaluationID));
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
			try { if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
		}
		return -1; //데이터베이스 오류
	}
//삭제
	public int delete(String evaluationID) {
		String SQL = "DELETE FROM EVALUATION WHERE evaluationID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(evaluationID));
			return pstmt.executeUpdate();
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
			try { if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
		}
		return -1; //데이터베이스 오류
	}
//글의 유저ID
	public String getUserID(String evaluationID) {
		String SQL = "SELECT userID FROM EVALUATION WHERE evaluationID = ?";
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conn = DatabaseUtil.getConnection();
			pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, Integer.parseInt(evaluationID));
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			try { if(conn != null) conn.close();} catch (Exception e) {e.printStackTrace();}
			try { if(pstmt != null) pstmt.close();} catch (Exception e) {e.printStackTrace();}
			try { if(rs != null) rs.close();} catch (Exception e) {e.printStackTrace();}
		}
		return null; //데이터베이스 오류
	}
}
