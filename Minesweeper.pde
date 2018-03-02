import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = (int)(Math.random()*50)+50;
private MSButton[][] buttons; //2d array of minesweeper buttons
 //ArrayList of just the minesweeper buttons that are mined
private ArrayList <MSButton> bombs;
//private ArrayList <MSButton> bombs= new ArrayList <MSButton>();
void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    bombs = new ArrayList <MSButton> ();
    buttons= new MSButton[NUM_ROWS][NUM_COLS]; //your code to declare and initialize buttons goes here
    for(int r=0; r< NUM_ROWS;r++){
      for(int c=0; c< NUM_COLS;c++){
        buttons[r][c]= new MSButton(r,c);
      }
    }
    setBombs();
}
public void setBombs()
{
   while(bombs.size()< NUM_BOMBS){
   int r= (int)(Math.random()*NUM_ROWS);
   int c= (int)(Math.random()*NUM_COLS);
   if(!bombs.contains(buttons[r][c]))
   {
     bombs.add(buttons[r][c]);
     System.out.print(r+","+c+"\t");
    }
   }
  
}
public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    int bombWin = 0;
    for (int i = 0; i < bombs.size(); i++)  
    {
        if (bombs.get(i).isMarked())
            bombWin++;
    }
    if (bombWin == bombs.size())
        return true;
    return false;
}
public void displayLosingMessage()
{
    for(int r=0; r < NUM_ROWS;r++){
      for(int c=0; c < NUM_COLS;c++){
        if(bombs.contains(buttons[r][c])){
         buttons[r][c].setLabel("B"); 
        }
      }
    }
    for (int b = 0; b < bombs.size(); b++){
    if (bombs.get(b).isMarked() == false){
      bombs.get(b).clicked = true;
    }
   }
   String loseDeath = new String("You Lose!");
    for (int i = 0; i < loseDeath.length(); i++)
    {
        buttons[NUM_ROWS/2][(NUM_COLS/2) - 5 + i].setLabel(loseDeath.substring(i, i+1));
    }
}
public void displayWinningMessage()
{
    String winSurvive = new String("You Win!");
    for (int i = 0; i < winSurvive.length(); i++)
    {
        buttons[NUM_ROWS/2][(NUM_COLS/2) - 5 + i].setLabel(winSurvive.substring(i, i+1));
    }
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
          
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if (mouseButton == RIGHT)//defuse 
        {
            marked = !marked;
            if (marked == false)
                clicked = false;
        }
        else if (bombs.contains(this) && marked==false){
            displayLosingMessage();
        }
        else if(countBombs(r,c) > 0){
          int num = countBombs(r,c);
          stroke(200,200,0);
          setLabel(""+num);
        }
        else
        {
          if(this.isValid(r,c-1)==true && buttons[r][c-1].clicked==false)
            buttons[r][c-1].mousePressed();
          
          if(this.isValid(r,c+1)==true && buttons[r][c+1].clicked==false)
            buttons[r][c+1].mousePressed();
          
          if(this.isValid(r+1,c)==true && buttons[r+1][c].clicked==false)
            buttons[r+1][c].mousePressed();
          
          if(this.isValid(r-1,c)==true && buttons[r-1][c].clicked==false)
            buttons[r-1][c].mousePressed();
          
          //if(this.isValid(r+1,c-1)==true && buttons[r+1][c-1].clicked==false)
          //  buttons[r+1][c-1].mousePressed();
          
          //if(this.isValid(r-1,c-1)==true && buttons[r-1][c-1].clicked==false)
          //  buttons[r-1][c-1].mousePressed();
          
          //if(this.isValid(r+1,c+1)==true && buttons[r+1][c+1].clicked==false)
          //  buttons[r+1][c+1].mousePressed();
          
          //if(this.isValid(r-1,c+1)==true && buttons[r-1][c+1].clicked==false)
          //  buttons[r-1][c+1].mousePressed();
          
        } 
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
         else if( clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 0,109,0 );
        else 
            //fill(50,(int)(Math.random()*200),10);
            fill( 0,59,0 );
        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        if(r>-1&&r< NUM_ROWS &&c>-1&&c< NUM_COLS){
       return true;
     }
     else
     {
     return false;
     }
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        if(isValid(r,c+1)==true && bombs.contains(buttons[r][c+1])){
            numBombs++;
          }
          if(isValid(r,c-1)==true && bombs.contains(buttons[r][c-1])){
            numBombs++;
          }
          if(isValid(r+1,c)==true && bombs.contains(buttons[r+1][c])){
            numBombs++;
          }
          if(isValid(r-1,c)==true && bombs.contains(buttons[r-1][c])){
            numBombs++;
          }
          if(isValid(r+1,c+1)==true && bombs.contains(buttons[r+1][c+1])){
            numBombs++;
          }
          if(isValid(r+1,c-1)==true && bombs.contains(buttons[r+1][c-1])){
            numBombs++;
          }
          if(isValid(r-1,c+1)==true && bombs.contains(buttons[r-1][c+1])){
            numBombs++;
          }
          if(isValid(r-1,c-1)==true && bombs.contains(buttons[r-1][c-1])){
            numBombs++;
          }
        
        return numBombs;
    }
}

