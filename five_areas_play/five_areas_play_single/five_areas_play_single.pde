import processing.video.*;
import deadpixel.keystone.*;



Movie currentMovie;
int numMovies = 3;   //broj razlicitih filmova (ne ukupni broj filmova)
int numDigits = 2;   //broj cifara koje imas u imenu videa (u ovom mom primeru je 2, inace koliko sma shvatio je 3)
StringList AMovies = new StringList();


String mpath = "/Users/mladenlazarevic/Desktop/tesla_test/";  //path do foldera
//String intro_path = 
//String outro_path = 

int intro_running = 1;
int outro_running = 0;

FloatDict videos_speed;

String currentGroup;
int currentNumber;
float k;

void setup() {
  fullScreen();
  frameRate(30);
   
  //kreiranje listi
  for (int i = 0; i < numMovies; i++ ) {
    String s;
    s = preprocess_number(numDigits, i+1);
    AMovies.append(mpath + "A"+ s + ".mov"); 
 
  }
  
  
  currentNumber = floor(random(0,numMovies)); //ovo se menja kad se ne klikce
  currentMovie = new Movie(this, AMovies.get(currentNumber));
  currentGroup = "A";
  currentMovie.play();
  
  //Dict init
  videos_speed = new FloatDict();
  videos_speed.set("A", 1);
  videos_speed.set("B", 3);
  videos_speed.set("C", -0.5);
  videos_speed.set("D", 0.5);
  videos_speed.set("E", -3);
}


void draw() {
  if (currentMovie.available()) {
    currentMovie.read();
  }
  image(currentMovie, 0,0);
  
  
  
  float mt = currentMovie.time();
  float md = currentMovie.duration();

  print(md);
  if (mt==md){
    play_rand(currentGroup);
    
    //set flag that intro is finished
    if (intro_running == 1) {
      intro_running = 0;
    }
  }
}


void mouseReleased() {
  
  if (intro_running != 1 && outro_running != 1) {
    jumpWhere();// myMovie.jump(random(myMovie.duration()));
  }
}


//jumpWhere -tested -done
//detektuje da li je mis pritisnut na segmentu A, B, C, D ili E
void jumpWhere() {
  int r = int(height/4);
  int newR = int(sqrt(pow((height/2-mouseY),2)+pow((width/2-mouseX),2.0)));
  
  if (newR<r){  
    goTo("A"); 
  }
  else if (mouseX<width/2)
  {
    if (mouseY<height/2)
    {
      goTo("B"); 
    }
    else
    {
      goTo("D"); 
    }
  }
  else
  {
    if (mouseY<height/2)
    {
      goTo("C"); 
    }
    else
    {
      goTo("E"); 
    }
  }
}



//na osnovu dela ekrana na koji smo kliknuli, ucitava film iz te grupe za pustanje
void goTo(String group)
{
  //ovo znaci da smo kliknuli na neki drugi frejm
  if (group != currentGroup){
    //k = videos_speed.get(currentGroup)/videos_speed.get(group);
    
    currentMovie.speed(videos_speed.get(group));
    currentGroup = group; 
  }
}


//funkcija koja posta na rand sledeci video kad se jedan zavrsi
void play_rand(String group){
  
  int rendom = floor(random(0,numMovies));
  print(rendom);
  print("stop");
  
  Movie nextMovie = null;
  nextMovie = new Movie(this, AMovies.get(rendom));
  
  currentMovie.stop();
  currentMovie = nextMovie;
  currentMovie.play();
  print("play");
  currentMovie.speed(videos_speed.get(group));
  
  currentNumber = rendom;
}


String preprocess_number(int numDigits, int currentI){
  String s="";
  for (int i = (numDigits-1); i>0; i--){
    if (floor(currentI / pow(10, i))<1){
      s+="0";  
  }
  }
  s =s+str(currentI);
  print(s);
  return s;
}

void movieEvent(Movie m) { 
  m.read(); 
}