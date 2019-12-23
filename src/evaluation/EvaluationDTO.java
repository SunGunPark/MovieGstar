package evaluation;

public class EvaluationDTO {
	
	int evaluationID;
	String userID;
	String movieName;
	String movieDivide;
	String evaluationTitle;
	String evaluationContent;
	String storyScore;
	String actorScore;
	String techScore;
	String totalScore;
	int likeCount;
	public int getEvaluationID() {
		return evaluationID;
	}
	public void setEvaluationID(int evaluationID) {
		this.evaluationID = evaluationID;
	}
	public String getUserID() {
		return userID;
	}
	public void setUserID(String userID) {
		this.userID = userID;
	}
	public String getMovieName() {
		return movieName;
	}
	public void setMovieName(String movieName) {
		this.movieName = movieName;
	}
	public String getMovieDivide() {
		return movieDivide;
	}
	public void setMovieDivide(String movieDivide) {
		this.movieDivide = movieDivide;
	}
	public String getEvaluationTitle() {
		return evaluationTitle;
	}
	public void setEvaluationTitle(String evaluationTitle) {
		this.evaluationTitle = evaluationTitle;
	}
	public String getEvaluationContent() {
		return evaluationContent;
	}
	public void setEvaluationContent(String evaluationContent) {
		this.evaluationContent = evaluationContent;
	}
	public String getStoryScore() {
		return storyScore;
	}
	public void setStoryScore(String storyScore) {
		this.storyScore = storyScore;
	}
	public String getActorScore() {
		return actorScore;
	}
	public void setActorScore(String actorScore) {
		this.actorScore = actorScore;
	}
	public String getTechScore() {
		return techScore;
	}
	public void setTechScore(String techScore) {
		this.techScore = techScore;
	}
	public String getTotalScore() {
		return totalScore;
	}
	public void setTotalScore(String totalScore) {
		this.totalScore = totalScore;
	}
	public int getLikeCount() {
		return likeCount;
	}
	public void setLikeCount(int likeCount) {
		this.likeCount = likeCount;
	}
	public EvaluationDTO() {
		
	}
	public EvaluationDTO(int evaluationID, String userID, String movieName, String movieDivide, String evaluationTitle,
			String evaluationContent, String storyScore, String actorScore, String techScore, String totalScore,
			int likeCount) {
		super();
		this.evaluationID = evaluationID;
		this.userID = userID;
		this.movieName = movieName;
		this.movieDivide = movieDivide;
		this.evaluationTitle = evaluationTitle;
		this.evaluationContent = evaluationContent;
		this.storyScore = storyScore;
		this.actorScore = actorScore;
		this.techScore = techScore;
		this.totalScore = totalScore;
		this.likeCount = likeCount;
	}
}
