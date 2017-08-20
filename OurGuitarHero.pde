float rate, cell_w, cell_h;
int cells_per_screen, start, end;
color[] colors = { #E82A2A, #E8D52A, #36E82A, #2AE8E6, #2A32E8, #DB2AE8 };
int[][] song;
int[][] scoring_sheet;
boolean scored;
String final_score = "";
char[] key_bindings ={ 'z', 'x', 'c', 'v', 'b', 'n' };
boolean[] held;

void setup() {
  size(600, 600);
  
  String[] data = loadStrings( "Greensleeves.txt" ); //........................loading our song file
  song = new int[ data.length ][ data[0].length() ];
  
  for( int i = 0; i < data.length; ++i ){//............................."guitar strings" along the first index
    for( int j = 0; j < data[i].length(); ++j ){//...................... time along the second.
      if( data[i].charAt(j) == '-' ) song[i][j] = -1;
      else song[i][j] = int( data[i].charAt(j) ) -48;
    }
  }
  scoring_sheet = new int[ song.length ][ song[0].length ];//........... Scoring sheet stores the player's perfomance so we can 
  for( int i = 0; i < song.length; ++i ){//                              give them a score at the end. It's an array the same shape
    for( int j = 0; j < song[0].length; ++j ){//                         and size as the song, but it's integer values instead of boolean.
      scoring_sheet[i][j] = -1;
    }
  }
  held = new boolean[key_bindings.length];//............................ our keyboard infomation.
  rate = 300; //........................................................ song speed. 200 milliseconds per cell ( 5 cells per second )
  cell_w = 500/ (float) song.length;//.................................................... shape of the note cell.
  cell_h = 0.8 * cell_w;
  cells_per_screen = ceil(height / cell_h) + 1;
  
  stroke(#A4BFBC);
  textSize(72);
  textAlign( CENTER, CENTER );
  
  end = 0;//..................... time when the song will be over.
  scored = true;
  final_score = "Press any key to\nstart playing";
}

void draw() {
  background(20);
  
  if( millis() < end ){//.............................................. main game loop.
    float current_cell = (millis()-start) / rate;
    int n = floor( current_cell );
    translate( 0, current_cell * cell_h ); //.......................... translate scrolls the song upwards.
    
    for( int i = 0; i < song.length; ++i ){
      float x = 50+(i*cell_w);
      for( int j = n; j < n+cells_per_screen && j < song[0].length; ++j ){
        if( j == n && held[i] ) fill(255);//............................ white if key is being held
        else if( song[i][j] >= 0 ) fill( colors[i] );//...................... guitar-string color 
        else fill( 20 );//.............................................. background color for all empty cells.
        rect( x, height - ((j+1)*cell_h), cell_w, cell_h );//........... draw the note cell.
      }
    }
  }
  else{//.............................................................. after end of the game:
    if( scored ){
      text( final_score, width/2f, height/2f );//...................... after scoring, show the final score.
    }
    else{//............................................................ Scoring procedure:
      int max_score = 0, score = 0;
      for( int i = 0; i < song.length; ++i ){
        for( int j = 0; j < song[0].length; ++j ){
          if( song[i][j] >= 0 ){
            max_score += rate;
            if( scoring_sheet[i][j] >= 0 ) score += rate - scoring_sheet[i][j];// score a correct note based on how well-timed it was played.
            else score -= rate; //penalty for missing a note.
          }
          else{
            if( scoring_sheet[i][j] >= 0 ){
              if( song[i][j+1] >= 0 ); // here goes the pity points for playing a note too early ( empty = no bonus ).
              else score -= rate; // penalty for playing a note at the wrong time.
            }
          }
        }
      }
      float S = constrain(map( score, -max_score, max_score, 0, 100 ), 0, 100);// map the scores and penalties to a percentage score.
      final_score =  nf(S, 2, 1) + "%" ;
      fill( colors[ round( 0.05 * S ) ] );
      scored = true;//........................................... end scoring procedure, ready to show score text (on the next frame)
    }
  }
}

void keyPressed(){
  if( millis() > end ){//................................................. Reset Game
    end = ceil( millis()+(rate * song[0].length) );//..................... time when the song will be over.
    start = millis();
    scored = false;
    scoring_sheet = new int[ song.length ][ song[0].length ];
    for( int i = 0; i < song.length; ++i ){
      for( int j = 0; j < song[0].length; ++j ){
        scoring_sheet[i][j] = -1;
      }
    }
  }
  int n = floor( (millis()-start) / rate );
  for( int i = 0; i < key_bindings.length; ++i ){
    if( key == key_bindings[i] ){//.................................. when we hit one of the keys in keybinding
      scoring_sheet[i][n] = round( (millis()-start) - (n*rate) );//   record how late the note was hit in milliseconds.
      held[i] = true;//.............................................. track which of our keys are being held.
    }
  }
}
void keyReleased(){
  for( int i = 0; i < key_bindings.length; ++i ){
    if( key == key_bindings[i] ){
      held[i] = false;//............................................. track which of our keys are being held.
    }
  }
}