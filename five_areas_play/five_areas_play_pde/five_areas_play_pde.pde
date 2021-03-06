import processing.video.*;
import deadpixel.keystone.*;


int m = 1000;
int s = 0;
int inactive = 40;

Movie currentMovie;
int numParts = 5;  //broj razlicitih tipova istog filma
int numMovies = 3;   //broj razlicitih filmova (ne ukupni broj filmova)
int numDigits = 2;   //broj cifara koje imas u imenu videa (u ovom mom primeru je 2, inace koliko sma shvatio je 3)
StringList AMovies = new StringList();
StringList BMovies = new StringList();
StringList CMovies = new StringList();
StringList DMovies = new StringList();
StringList EMovies = new StringList();


String mpath = "/Users/mladenlazarevic/Desktop/tesla_test/";  //path do foldera
String intro_path = "/Users/mladenlazarevic/Desktop/TENK/MVI_8572.MOV";
String outro_path = "/Users/mladenlazarevic/Desktop/TENK/MVI_8572.MOV";
String trailer_path = "/Users/mladenlazarevic/Desktop/TENK/MVI_8583.MOV";

int intro_running = 1;
int outro_running = 0;
int trailer = 0;

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
    BMovies.append(mpath + "B"+ s + ".mov"); 
    CMovies.append(mpath + "C"+ s + ".mov"); 
    DMovies.append(mpath + "D"+ s + ".mov"); 
    EMovies.append(mpath + "E"+ s + ".mov"); 
 
  }
  
  
  currentNumber = floor(random(0,numMovies)); //ovo se menja kad se ne klikce
  currentMovie = new Movie(this, intro_path);
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
   
  int t = (minute()*60+second()-m*60-s);
  print(t);

  if (t>=inactive && trailer ==0)
  {
    m = minute();
    s = second();
    currentMovie.stop();
    currentMovie = new Movie(this, outro_path);
    currentMovie.play();
    trailer = 1;
    outro_running =1;
  }
  
  float mt = currentMovie.time();
  float md = currentMovie.duration();
  
  if (mt==md){
    outro_running=0;
    
    if (trailer ==0){
    play_rand(currentGroup);
    
    }
    else
    {
      currentMovie.stop();
      currentMovie = new Movie(this, trailer_path);
      currentMovie.play();
    }
    
    //set flag that intro is finished
    if (intro_running == 1) {
      intro_running = 0;
      
      currentMovie.stop();
      currentMovie = new Movie(this, AMovies.get(currentNumber));
      currentGroup = "A";
      currentMovie.play();
    }
  }
}


void mouseReleased() {
  m = minute();
  s = second();
  
  //turn the trailer off
  trailer =0;
  
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
    k = videos_speed.get(currentGroup)/videos_speed.get(group);
    Movie nextMovie = null;
    
    if (group == "A")
    {
      nextMovie = new Movie(this, AMovies.get(currentNumber));
    }
    else if (group == "B")
    {nextMovie = new Movie(this, BMovies.get(currentNumber));}
    else if (group == "C")
    {nextMovie = new Movie(this, CMovies.get(currentNumber));}
    else if (group == "D")
    {nextMovie = new Movie(this, DMovies.get(currentNumber));}
    else if (group == "E")
    {nextMovie = new Movie(this, EMovies.get(currentNumber));}
    else
    {print("error");}
       
    howtoJump(nextMovie, k);
    
    currentGroup = group; 
  }
}


//funkcija koja posta na rand sledeci video kad se jedan zavrsi
void play_rand(String group){
  
  int rendom = floor(random(0,numMovies));
  print(rendom);
  print("stop");
  
  Movie nextMovie = null;
  
  if (group == "A")
    {nextMovie = new Movie(this, AMovies.get(rendom));
    }
    else if (group == "B")
    {nextMovie = new Movie(this, BMovies.get(rendom));}
    else if (group == "C")
    {nextMovie = new Movie(this, CMovies.get(rendom));}
    else if (group == "D")
    {nextMovie = new Movie(this, DMovies.get(rendom));}
    else if (group == "E")
    {nextMovie = new Movie(this, EMovies.get(rendom));}
    else
    {print("error");}
    
  if (nextMovie!=null)
  {
  currentMovie.stop();
  currentMovie = nextMovie;
  currentMovie.play();
  
  currentNumber = rendom;
}
}


//funckija koja odreduje trenutak na koji treba da se skoci kad se klikne misem
void howtoJump(Movie m, float f)
{
  
  float theTime = currentMovie.time();
  
  currentMovie.stop();  //zaustavlja se putanje trenutnog filma - ovo sam dodao jer sam u nekom drugom delu imao bagove, pa da sprecim potencijalne bugove ovde
  //sad je zakomentarisamo ali mozda bude trebalo da se otkomentarise
  
  
  currentMovie = m; 
  currentMovie.play();  //okidao sam play prvo na kraju ove funckije, zbog sto smoothles tranzicije sa jednog na drugi video, tj tek
  //nakon sto se odradi jump, ali onda ima bug sto ne mzoe da procita durattion(), jer film nije pusten
  
  if (f>0)
  {
    currentMovie.jump(f*theTime); 
  }
  else
  {
    currentMovie.jump(currentMovie.duration()+f*theTime);
  }
  //currentMovie.play();
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