boolean recording = false;

PImage img, imgCopy;

int pixelSize = 5;
color c;
Player player;

ArrayList<Particle> particles = new ArrayList<Particle>();

void setup(){
  size(800, 600);
 
  img = loadImage("tower02.jpg");
  imgCopy = createImage(img.width, img.height, RGB);
 

  
  for(int x = 0; x < img.width; x += pixelSize){
    for(int y = 0; y < img.height; y += pixelSize){
      
      //pixel의 2D 위치계산
      int loc = x + y*img.width;
      //이미지로 부터 R,G,B 값을 가져옴
      float r = red (img.pixels[loc]);
      float g = green (img.pixels[loc]);
      float b = blue (img.pixels[loc]);
   
      c = color(r, g, b);
      
      particles.add(new Particle(new PVector(x, y),c)); 
      
      
    }
  }
  
  //player
  player = new Player();
  
}


void draw() {
  
   if (recording) {
    saveFrame("output/frames####.png");
  }
  background(0);
  image(img, 0, 0);
  
  
  for (int i = particles.size()-1; i >= 0; i--){ 
    Particle p = particles.get(i);
    p.update();
    p.display();

    if(p.isDead()){
      particles.remove(i);
    }
  }
  
  //player
  player.update();
  player.display();

}

void keyPressed() {
  
  // If we press r, start or stop recording!
  if (key == 'r' || key == 'R') {
    recording = !recording;
  }
}

class Player {
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  Player(){
    location = new PVector(width/2, height/2);
    velocity = new PVector(random(-3, 5), random(-3, 5));
    acceleration = new PVector(0,0);
  }
  
  void update(){
    velocity.add(acceleration);
    location.add(velocity);
    if(location.x < width/2  || location.x > width-10){ 
      velocity.x = velocity.x * -1;
      acceleration.x = random(-0.1,0.1);
    }
    if(location.y < 10 || location.y > height-10){
      velocity.y = velocity.y * -1;
      acceleration.y = random(-0.1,0.1);
      
    }
    velocity.limit(5); 
  }
  
  void display(){
    fill(0, 255, 0);
    noStroke();
    ellipse(location.x, location.y, 20, 20);
  }

}

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  color cc;
  
  Particle(PVector p, color c){
    acceleration = new PVector(0.0, 0.0);
    velocity = new PVector(0, 0);
    location = p.copy();
    lifespan = 255.0;
    cc = c;
  }
  
  void update(){
    velocity.add(acceleration);
    location.add(velocity);
    
    if (dist(location.x + img.width, location.y, player.location.x, player.location.y) < 10){
      velocity.x = random(-1,1);
      velocity.y = random(-1,1);
    }
    if(location.x < 0 || location.x > width || location.y <0 || location.y > height){
      lifespan -= 2.0;
    }
  }
  
  void display(){
    stroke(0, lifespan);
    //noStroke();
    strokeWeight(1);
    fill(cc, lifespan);
    rect(location.x+img.width, location.y, pixelSize, pixelSize);
  }
  
  boolean isDead(){
    if (lifespan < 0.0){
      return true;
    } else {
      return false;
    }
  }
}
