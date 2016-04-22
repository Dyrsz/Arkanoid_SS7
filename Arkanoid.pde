Ball ball;
Pad pad;
Menu men;
byte ind;

void setup() {
  ball = new Ball (40, 40f);
  pad = new Pad (70, height/7);
  men = new Menu ();
  textAlign (CENTER);
}

void draw () {
  men.display (ind);
}

void mousePressed  () {
  if (ind != 1) men.mouseP (ind, byte (0));
}

class Ball {
  int rad;
  float vel;
  int x;
  int y;
  float vx;
  float vy;
  float modv;
  float rec;
  
  Ball (int trad, float tvel) {
    rad = trad;
    vel = tvel;
    x = width/2;
    y = height/2;
    vx = random (-100, 100);
    vy = random (-100, 100);
    modv = sqrt (vx*vx + vy*vy);
    rec = vel/modv;
    vx = vx * rec;
    vy = vy * rec;
  }
  
  void display () {
    fill(200);
    noStroke ();
    ellipse (x, y, 2*rad, 2*rad);
    x += vx;
    y += vy;
    if (x+rad > width) {
      vx = -vx;
      x = width-rad;
    }
    if (y+rad > height) {
      vy = -vy;
      y = height-rad;
    }
    if (x-rad < 0) {
      vx = -vx;
      x = rad;
    }
    if (y-rad < 0) {
      vy = -vy;
      y = rad;
    }
  }
  
  void collision (int xl, int xr, int yt, int yb, boolean conPad) {
    if (x+rad > xl && y+rad > yt && y-rad < yb && x+rad-vx < xl) {
      vx = -vx;
      x = xl - rad;
    }
    if (x-rad < xr && y+rad > yt && y-rad < yb && x-rad-vx > xr) {
      vx = -vx;
      x = xr + rad;
    }
    if (y+rad > yt && x+rad > xl && x-rad < xr && y+rad-vy < yt) {
      vy = -vy;
      y = yt - rad;
      if (conPad && mousePressed) {
        if (mouseX > x) vx += vel/2;
        if (mouseX < x) vx -= vel/2;
        modv = sqrt (vx*vx + vy*vy);
        rec = vel/modv;
        vx = rec * vx;
        vy = rec * vy;
      }
    }
    if (y-rad < yb && x+rad > xl && x-rad < xr && y-rad-vy > yb) {
      vy = -vy;
      y = yb + rad;
    }
  }
  
}

class Pad {
  int x = width/2;
  int y;
  int vel;
  
  Pad (int tvel, int talt) {
    y = height - talt;
    vel = tvel;
  }
  
  void display () {
    noStroke  ();
    fill (200);
    rect (x-100, y-25, 200, 50);
  }
  
  void move (int mx) {
    if (mx < x && x > 110) x -= vel;
    if (mx > x && x < width-110) x += vel;
  }
}

class Menu {
  Menu () {}
  
  void display  (byte tind) {
    if (tind == 0) {
      background  (0);
      stroke (110);
      fill (200);
      textSize (70);
      text ("Pulsa la pantalla para comenzar", width/2, height/3);
      noLoop ();
    } else if (tind == 1) { // juego.
      background  (0);
      ball.display ();
      pad.display ();
      ball.collision (pad.x-100, pad.x+100, pad.y-25, pad.y+25, true);
      if (mousePressed) pad.move (mouseX);
    }
  }
  
  void mouseP (byte tind, byte tie) {
    if (tind == 0) {
      ind = 1;
      loop ();
    }
    // tie si hay botones.
  }
  
}