import uibooster.UiBooster;
import uibooster.model.Form;
import uibooster.model.FormElement;
import java.awt.Font;


void launchGUI(String titleSongA, String artistSongA, String titleSongB, String artistSongB) {
  new UiBooster(new Font("Elephant", Font.PLAIN, 16))
    .createForm("Song Selector")
    .addLabel ("Please choose your favourite song!") 
    //.setID("chooseOption") 
    .addLabel("Song A: " + titleSongA + " : " + artistSongA)
    .setID("songA")
    .addLabel("Song B: " + titleSongB + " : " + artistSongB)
    .setID("songB")
    .addButton("Select Song A", () -> doNothing())
    .setID("selectA")
    .addButton("Select Song B", () -> doNothing())
    .setID("selectB")
    .addButton("I Don't Know", () -> doNothing())
    .setID("noOpinion")
    .setChangeListener((element, value, form) -> extractUserInputForSketch(element, form))
    .run();
}

void extractUserInputForSketch(FormElement element, Form form) {
  String songDescription = "no selection";
  
  switch (element.getId()) {
  case "selectA":
    songDescription = form.getById("songA").asString();
    highEnergy++;
    
    break;
  case "selectB":
    songDescription = form.getById("songB").asString();
    lowEnergy++;
    break;
  }

  if (songDescription.equals("no selection") == false) {
    String [] parts = songDescription.split(":");
    Song s = new Song(trim(parts[1]), trim(parts[2]));
    s.getLyrics();
    songs.add(s);
    println(s.sentiment());
  }

  questionCount++;
  if(questionCount == 4){
    displayPersonality();
  }
  for(int i = 0; i < dataset.getRowCount(); i++){
   if(dataset.getInt(i, "volume_number") == currentPosition){
      energy.add(dataset.getFloat(i, "energy"));
   }
  }
  float max = Collections.max(energy);
  float min = Collections.min(energy);
  String songATitle = dataset.getString(energy.indexOf(max) + indexLen, "title");
  String songAArtist = dataset.getString(energy.indexOf(max) + indexLen, "artist");
  String songBTitle = dataset.getString(energy.indexOf(min) + indexLen, "title");
  String songBArtist = dataset.getString(energy.indexOf(min) + indexLen, "artist");
  form.getById("songA").setValue("Song A: " + songATitle + " : " + songAArtist);
  form.getById("songB").setValue("Song B: " + songBTitle + " : " + songBArtist);
  
  currentPosition++;
  indexLen = indexLen + energy.size();
  energy.clear();
}

void doNothing() {
}

void displayPersonality(){
  new UiBooster(new Font("Elephant", Font.PLAIN, 16))
    .createForm("Song Selector")
    .addLabel ("Check Display for Personality Trait") 
    //.setID("chooseOption") 
    .addButton("Exit", () -> doNothing())
    .setID("exit")
    .setChangeListener((element, value, form) -> closeProgram())
    .run();
}

void closeProgram(){
  exit();
}
