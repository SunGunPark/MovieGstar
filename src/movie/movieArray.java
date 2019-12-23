package movie;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class movieArray {
	
	public JSONArray movieSearch(String search) {
		StringBuilder sb;
		String clientId = "GY2GyvIauAhwX7tsVxwG";//애플리케이션 클라이언트 아이디값";
        String clientSecret = "qZGzfwYInC";//애플리케이션 클라이언트 시크릿값";
        int display = 10; // 검색결과갯수. 최대100개
        try {
            String text = URLEncoder.encode(search, "utf-8");
            String apiURL = "https://openapi.naver.com/v1/search/movie.json?query=" + text + "&display=" + display + "&";
 
            URL url = new URL(apiURL);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");
            con.setRequestProperty("X-Naver-Client-Id", clientId);
            con.setRequestProperty("X-Naver-Client-Secret", clientSecret);
            int responseCode = con.getResponseCode();
            BufferedReader br;
            if (responseCode == 200) { 
                br = new BufferedReader(new InputStreamReader(con.getInputStream(),"UTF-8"));
            } else { 
                br = new BufferedReader(new InputStreamReader(con.getErrorStream(),"UTF-8"));
            }
            sb = new StringBuilder();
            String line;
            while ((line = br.readLine()) != null) {
                sb.append(line + "\n");
            }
            br.close();
            con.disconnect();
            JSONParser parser = new JSONParser();
            JSONObject obj = (JSONObject)parser.parse(sb.toString());
            JSONArray item = (JSONArray)obj.get("items");
            return item;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
