import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

import com.vader.sentiment.analyzer.SentimentAnalyzer;
import com.vader.sentiment.analyzer.SentimentPolarities;
  
class Song {
  final String SERVICE_URL = "https://www.musixmatch.com/lyrics";
  
  String title;
  String artist;
  String lyrics;
  
  Song(String title, String artist) {
    this.title = title;
    this.artist = artist;
  }
  
  String getLyrics() {
    if (this.lyrics == null) {
      String page = String.format("%s/%s/%s", SERVICE_URL, this.artist.replace(' ', '-'), this.title.replace(' ', '-'));
      this.lyrics = processLyrics(page);
    }
    
    return this.lyrics;
  }
  
  String processLyrics(String url) {
    String lyricsString = null;
    
    try {
      Document doc = Jsoup.connect(url).get();
      Elements lyrics = doc.select("span.lyrics__content__ok");
      lyricsString = lyrics.text();
    }
    catch (IOException exception) {
      return null;
    }
    
    return lyricsString;
  }
  
  String sentiment() {
    SentimentPolarities sentimentPolarities = SentimentAnalyzer.getScoresFor(this.lyrics);
    return sentimentPolarities.toString(); // also float sentimentPolarities.getPositivePolarity() (or Negative, Neutral, Compound)
  }
}
