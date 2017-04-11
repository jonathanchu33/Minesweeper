

import de.bezier.guido.*;
int NUM_ROWS = 20;
int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean gameOver = false;

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton [NUM_ROWS][NUM_COLS];
    for (int i = 0; i < buttons.length; i++)
    {
        for (int j = 0; j < buttons[i].length; j++)
            buttons[i][j] = new MSButton(i,j);
    }

    while (bombs.size() < 80)
        setBombs();
}
public void setBombs()
{
    int row = (int)(Math.random()*NUM_ROWS);
    int column = (int)(Math.random()*NUM_COLS);
    if (!bombs.contains(buttons[row][column]))
        bombs.add(buttons[row][column]);
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    for (int i = 0; i < NUM_ROWS; i++)
        for (int j = 0; j < NUM_COLS; j++)
            if (bombs.contains(buttons[i][j]) && !buttons[i][j].marked)
                return false;
    return true;
}
public void displayLosingMessage()
{
    buttons[10][5].setLabel("Y");
    buttons[10][6].setLabel("O");
    buttons[10][7].setLabel("U");
    buttons[10][9].setLabel("L");
    buttons[10][10].setLabel("O");
    buttons[10][11].setLabel("S");
    buttons[10][12].setLabel("E");
    buttons[10][14].setLabel(":");
    buttons[10][15].setLabel("(");

}
public void displayWinningMessage()
{
    buttons[10][5].setLabel("Y");
    buttons[10][6].setLabel("O");
    buttons[10][7].setLabel("U");
    buttons[10][9].setLabel("W");
    buttons[10][10].setLabel("I");
    buttons[10][11].setLabel("N");
    buttons[10][12].setLabel("!");
    buttons[10][14].setLabel(":");
    buttons[10][15].setLabel(")");
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
        if (gameOver)
            return;
        clicked = true;
        if (keyPressed)
        {
            marked = !marked;
            if (marked == false)
                clicked = false;
        }
        else if (bombs.contains(this))
        {
            displayLosingMessage();
            gameOver = true;
        }
        else if (countBombs(r, c) > 0)
            label = Integer.toString(countBombs(r, c));
        else //if (countBombs(r, c) == 0)
        {
            /*for (int i = -1; i < 2; i++)
                for (int j = -1; j < 2; j++)
                    if (i != 0 && j != 0 && isValid(r+i,c+j) && buttons[r+1][c+1].clicked == false)
                        buttons[r+i][c+j].mousePressed();*/
            if (isValid(r-1,c-1) && buttons[r - 1][c - 1].clicked == false)
                buttons[r-1][c-1].mousePressed();
            if (isValid(r-1,c) && buttons[r - 1][c].clicked == false)
                buttons[r-1][c].mousePressed();
            if (isValid(r-1,c+1) && buttons[r - 1][c + 1].clicked == false)
                buttons[r-1][c+1].mousePressed();
            if (isValid(r,c-1) && buttons[r][c - 1].clicked == false)
                buttons[r][c-1].mousePressed();
            if (isValid(r,c+1) && buttons[r][c + 1].clicked == false)
                buttons[r][c+1].mousePressed();
            if (isValid(r+1,c-1) && buttons[r + 1][c - 1].clicked == false)
                buttons[r+1][c-1].mousePressed();
            if (isValid(r+1,c) && buttons[r + 1][c].clicked == false)
                buttons[r+1][c].mousePressed();
            if (isValid(r+1,c+1) && buttons[r + 1][c + 1].clicked == false)
                buttons[r+1][c+1].mousePressed();
        }
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

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
        if (r < NUM_ROWS && c < NUM_COLS && r >= 0 && c >=0)
            return true;
        else
            return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        /*for (int i = -1; i < 2; i++)
            for (int j = -1; j < 2; j++)
                if (i != 0 && j != 0 && isValid(row+i,col+j) && bombs.contains(buttons[row+i][col+j]))
                    numBombs++;*/
        if (isValid(row-1,col-1) && bombs.contains(buttons[row-1][col-1]))
            numBombs++;
        if (isValid(row-1,col) && bombs.contains(buttons[row-1][col]))
            numBombs++;
        if (isValid(row-1,col+1) && bombs.contains(buttons[row-1][col+1]))
            numBombs++;
        if (isValid(row,col-1) && bombs.contains(buttons[row][col-1]))
            numBombs++;
        if (isValid(row,col+1) && bombs.contains(buttons[row][col+1]))
            numBombs++;
        if (isValid(row+1,col-1) && bombs.contains(buttons[row+1][col-1]))
            numBombs++;
        if (isValid(row+1,col) && bombs.contains(buttons[row+1][col]))
            numBombs++;
        if (isValid(row+1,col+1) && bombs.contains(buttons[row+1][col+1]))
            numBombs++;
        return numBombs;
    }
}



