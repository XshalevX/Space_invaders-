//                                aaaaaaaaaaaa                   a                                  aaaaaaaaaaaa      a
//                                a            a             a      a        eeeeeeeeee      a      a                 a                                         a              aaaaaaaaaa
//                                a             a           a        a       e                      a                 a                        aaa              a              a
//                                aaaaaaaaaaaaaa           a          a      e                      a                 a                       a    a            a              a               a           a
//                                a             a         a            a     e               a      aaaaaaaaaaaaa     a                      a      a           a              a               a           a
//                                a             a         a             a    e               a                  a     a aaaaaaaaa           a        a          a              a               a           a
//                                a              a         a            a    eeeeeeeeee      a                  a     a         a          a          a         a              aaaaaaaaaa       a         a
//                                a              a          a          a     e               a                  a     a         a         aaaaaaaaaaaaaa        a              a                 a       a
//                                a               a          a        a      e               a                  a     a         a        a              a       a              a                  a     a
//                                a               a           a      a       e               a       aaaaaaaaaaaa     a         a       a                a      a              a                   a   a
//                                a               a            a    a        e               a                        a         a      a                  a     a              a                    a a
//                                a               a               a          eeeeeeeeee      a                        a         a     a                    a    aaaaaaaaaaaa   aaaaaaaaaa            a    


int numOfCol = 10;
int numOfRow = 5;
int scorePerKill = 10;
int numOfMaxShots = 10;
int numOfCurrShots = 0;
int score = 0;
int currY = 1;
int currDir = 0;

int alienShotSpeed = 2;
int lastAlienShot;
int AlienShotRate = 2;
int numOfCurrAlienShots = 0;
int AlienMaxShots= 60/AlienShotRate;
Image[] arrAlienShots =new Image [AlienMaxShots];
boolean[] arrAlienShotsState = new boolean[AlienMaxShots];


int speedOfGoodSpaceShip =5;
int speedOfShot = 5;
int speedOfAlien =1;
int fontSize = 20;
int fontY = 20;
String textFont = "david";
color white = color(255,255,255);
color red = color(255,0,0);
Text tScore = new Text();
Text tNumOfShots = new Text();
Text tYouWint = new Text();
Text tGameOver = new Text();

boolean[][] arrAlienState = new boolean[numOfCol][numOfRow];
boolean[] arrShotsState = new boolean[numOfMaxShots];

Image[][] arrAlien = new Image[numOfCol][numOfRow];
Image goodspaceship= new Image();
Image[] arrShots = new Image[numOfMaxShots] ;

void setup() {
    size (1600,800); 
    background(0,0,0);
      
    tScore.text ="Score: " + score;
    tScore.x = 10;
    tScore.y = fontY;
    tScore.brush = white;
    tScore.textSize = fontSize;
    
    tNumOfShots.text = "Shots: " + numOfCurrShots + "/" + numOfMaxShots;
    tNumOfShots.y = fontY;
    tNumOfShots.brush = white;
    tNumOfShots.textSize = fontSize;
    tNumOfShots.x = 140;
    
    tYouWint.text = "YOU WIN!";
    tYouWint.y = height/2;
    tYouWint.x = width/4;
    tYouWint.textSize = 150;
    tYouWint.brush = white;
    
    tGameOver.text = "GAME OVER!";
    tGameOver.y = height/2;
    tGameOver.x = width/5;
    tGameOver.textSize = 150;
    tGameOver.brush = red;
    
    goodspaceship.setImage("goodspaceship.jpg");
    goodspaceship.x=400;
    goodspaceship.y=770;
    goodspaceship.width=100;
    goodspaceship.height=30;
    
    //init shots array
    for (int i=0; i<numOfMaxShots; i++)
    {
       arrShots[i] = new Image();
       arrShots[i].setImage("shot.png");
       arrShotsState[i] = false;
    }
    
    //init alien shots array
    for (int i=0; i<AlienMaxShots; i++)
    {
       arrAlienShots[i] = new Image();
       arrAlienShots[i].setImage("shot.png");
       arrAlienShotsState[i] = false;
    }
    
    //init alien 2D array
    for(int i=0; i<numOfCol; i++)
    {
     for(int j=0; j<numOfRow;j++)
     {
       arrAlien[i][j] = new Image();
       arrAlien[i][j].setImage("badalien.png");
       arrAlien[i][j].width=100;
       arrAlien[i][j].height=50;
       arrAlien[i][j].x=0;
       arrAlien[i][j].y= j * arrAlien[i][j].height + fontY ;
       if(i>0){
        arrAlien[i][j].x = arrAlien[i-1][j].x+arrAlien[i-1][j].width + 50;
        arrAlien[i][j].y = arrAlien[i-1][j].y;
       }
       arrAlien[i][j].direction=Direction.RIGHT;
       arrAlien[i][j].speed=speedOfAlien;
       arrAlienState[i][j]= true;
    }
  }
  lastAlienShot = second();
}

void updateYaxis()
{
  for(int i=0; i<numOfCol; i++)
 {
   for(int j=0; j<numOfRow;j++)
   {
      arrAlien[i][j].y += currY;
   }
 }
}

void draw() {
 //clear the screen
 background(0,0,0);
 
 
  // draw spaceShip
  goodspaceship.draw();
 
  //Draw all active shots
  for (int i=0; i<numOfMaxShots; i++)
  {
    if(arrShotsState[i] == true)
    {
      arrShots[i].draw();
    }
  }
  
  // Check Colisions
  for(int i=0; i<numOfCol; i++)
   {
     for(int j=0; j<numOfRow;j++)
     {
       for(int k=0;k<numOfMaxShots;k++)
       {
         //check if one of the shots hit one of the alien
         if(arrAlienState[i][j] == true && arrShotsState[k] == true && arrAlien[i][j].pointInShape(arrShots[k].x,arrShots[k].y))
         {
            arrAlienState[i][j]=false;
            arrShots[k].y = width + arrShots[k].width;
            arrShots[k].speed = 0;
            arrShotsState[k] = false;
            numOfCurrShots--;
            score += scorePerKill;
            continue;
         }
         // check if shot is out of scope (scree)
         if(arrShotsState[k] == true && arrShots[k].y == 0)
         {
            arrShotsState[k] = false;
            numOfCurrShots--;
         }
       }
       //check if some of the aliens hit the spaceShip
       if(arrAlienState[i][j] == true && goodspaceship.pointInShape(arrAlien[i][j].x,arrAlien[i][j].y))
       {
         tGameOver.draw();
         stop();
         return;
       }
      }
     }
     //Check if some of Alien shots hit the spaceShip
      
     // Check if alienShot timeout
     if(second()==(lastAlienShot+AlienShotRate) % 60)
     {
       randomAlienShoot();
       lastAlienShot = second();
     }
      
     //Draw all active alien shots
     for (int i = 0; i<AlienMaxShots; i++)
     {
        if(arrAlienShotsState[i] == true)
        {
          arrAlienShots[i].draw();
        }
         if(goodspaceship.pointInShape (arrAlienShots[i].x ,arrAlienShots[i].y))
         {
           tGameOver.draw();
           stop();
           return;
         }
      }
     
      //Draw all active aliens and calculate aliens direction  
     for(int i=0; i<numOfCol; i++)
     {
       for(int j=0; j<numOfRow;j++)
       {
         if (arrAlienState[i][j] == true && arrAlien[i][j].x<=0)
         {
           currDir=Direction.RIGHT;
           updateYaxis();
         }
         if (arrAlien[i][j].x+arrAlien[i][j].width>=width && arrAlienState[i][j] == true)
         {
           currDir=Direction.LEFT;
           updateYaxis();
         }
         arrAlien[i][j].direction=currDir;
         if(arrAlienState[i][j] == true)
           arrAlien[i][j].draw();
      } 
   }
 
   //update texts
   tScore.text ="Score: " + score;
   tNumOfShots.text = "Shots: " + numOfCurrShots +"/" + numOfMaxShots;
   
   //draw texts
   tScore.draw();
   tNumOfShots.draw();
   
   //check if win
   if(numOfCol * numOfRow * scorePerKill == score)
   {
      tYouWint.draw(); 
      stop();
      return;
   }
}
void randomAlienShoot()
{
   if(numOfCurrAlienShots < AlienMaxShots)
   {
    int randRow =int(random(0,numOfRow));
    int randCol = int(random(0,numOfCol));
    //look for random active alien
    while (arrAlienState[randCol][randRow] == false)
    {
      randRow =int(random(0,numOfRow));
      randCol = int(random(0,numOfCol));
    }
    // look for the first available alien shot
    for(int i = 0;i<AlienMaxShots;i++)
    {
      if(arrAlienShotsState[i] == false)
      {
        arrAlienShots[i].direction=Direction.DOWN;
        arrAlienShots[i].speed = alienShotSpeed;
        arrAlienShots[i].x = arrAlien[randCol][randRow].x + (arrAlien[randCol][randRow].width)/2;
        arrAlienShots[i].y = arrAlien[randCol][randRow].y + arrAlien[randCol][randRow].height;
        arrAlienShotsState[i] = true;
        numOfCurrAlienShots++;  
        break;
      }
    }
   }
}   

void keyReleased()
{
  goodspaceship.speed=0;
}

void keyPressed()
{
  if(keyCode==RIGHT){
    goodspaceship.direction=Direction.RIGHT;
    goodspaceship.speed=speedOfGoodSpaceShip;
  }
  if(keyCode==LEFT){
    goodspaceship.direction=Direction.LEFT;
    goodspaceship.speed=speedOfGoodSpaceShip;
  }
  if(keyCode==UP){
    if(numOfCurrShots < numOfMaxShots)
    {
      for(int i = 0;i<numOfMaxShots;i++)
      {
        if(arrShotsState[i] == false)
        {
           arrShots[i].direction=Direction.UP;
           arrShots[i].speed=speedOfShot;
           arrShots[i].x= goodspaceship.x+(goodspaceship.width)/2;
           arrShots[i].y= goodspaceship.y;
           arrShotsState[i] = true;
           numOfCurrShots++;  
           break;
        }
      }
    }
  }
}

 
  
  
  
  
  
  
  
  
