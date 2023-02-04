import java.util.*;

PFont displayFont;
PImage musicnotes; 

int Music; 

final String DATASET = "NOW-Kaggle-dataset.csv";
processing.data.Table dataset;


List<Song> songs;
int currentPosition = 1;
ArrayList<Float> energy = new ArrayList<Float>();
int indexLen;
int highEnergy = 0;
int lowEnergy = 0;
int questionCount = 0;

void setup() {
  size(960, 540);
  frameRate(1);
  
  displayFont = createFont("Elephant", 26);
  textFont(displayFont);
  
  
  musicnotes = loadImage("image1.png"); 
  Music = height - musicnotes.height + 80; 

  
  dataset = loadTable(DATASET, "header");
  songs = new ArrayList<>();
  ArrayList<Float> energy = new ArrayList<Float>();

  
  for(int i = 0; i < dataset.getRowCount(); i++){
    if(dataset.getInt(i, "volume_number") == currentPosition){
       energy.add(dataset.getFloat(i, "energy"));
    }
  }
  float max = Collections.max(energy);
  float min = Collections.min(energy);
  indexLen = energy.size();
  String firstSongATitle = dataset.getString(energy.indexOf(max), "title");
  String firstSongAArtist = dataset.getString(energy.indexOf(max), "artist");
  String firstSongBTitle = dataset.getString(energy.indexOf(min), "title");
  String firstSongBArtist = dataset.getString(energy.indexOf(min), "artist");
  
  currentPosition++;
  launchGUI(firstSongATitle, firstSongAArtist, firstSongBTitle, firstSongBArtist);
}

void draw() {
  background(#C35AD8);
  image(musicnotes, - 50, Music); 
  
  pushStyle();
  fill(#212127);
  for (Song s : songs) {
    text(s.title, random(2*width/3), random(height));
  }

  if(questionCount == 4){
    if(highEnergy >= 3){
      text("Extraversion: You prefer upbeat and conventional music!", 200, 200);
    }
    else if(lowEnergy >= 3){
      text("Extraversion: You are not extraverted!", 200, 200);
    }
  }
  else{
    text("Extraversion: Not enough data to decide", 200, 200);
  }
  
  
  popStyle();
}
