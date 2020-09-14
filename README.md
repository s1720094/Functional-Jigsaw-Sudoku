# Functional-Jigsaw-Sudoku
Jigsaw Sudoku is a variant of sudoku were each sudoku sub-grid can be a jigsaw piece of variable size. I have created a playable version that utilizes an input txt file to generate the board.

## Loading the Game

To first load Jigsaw Sudoku you must run the ghci compiler on the file second.hs
through the terminal. Once Main is compiled you need to enter the command main in
the terminal. This will then launch Jigsaw Sudoku on the terminal.

## Playing the Game

Once Jigsaw Sudoku loads you are welcomed to the game and asked to enter the
name of the file containing the board you wish to play with. Assuming the file name is
map.txt you must enter the full file name (including the suffix) in the terminal prompt. If
you enter a non-existent file you will be informed that there is no file with such name
and will then be consequently asked if you would like to try again or not. Entering ‘Y’ for
yes will trigger the same procedure of asking for the file name. Entering anything other
than Y including N for no, will quit the game with the exception ExitSuccess.
Assuming you have entered the correct file name the game proceeds to load the board
and display it on the terminal. Please note that when the board is printed out it only
displays the block divisions horizontally. For the vertical subdivisions of the blocks one
must refer to the text file they are using. Underneath the printed board you are asked to
enter a row coordinate. After you entered a row coordinate you are asked for a column
coordinate and then for a value to fill the row-column coordinate. The rows and columns
are numbered (0-8) and the values any coordinate can take are numbered (1-9). Once
all values are filled correctly and checked for validity against the board then a new
board is printed out with the recently added value now appearing on it and underneath
the same prompt for a row value. This process is repeated until the board fills up or the
player decides to quit. If a non integer value is input in the row, column or number
prompt the game automatically quits. When the game quits it asks you if you wish to
save your board. Clicking ‘Y’ for yes will save the current board in a text file of your
choice in the board format of the input file. In addition, if the inputs to row, column or
number are not valid then the game does not allow you to make that move and informs
you of your error. It then asks you if you wish to try again. Clicking ‘Y’ for yes will
retrigger the same prompt for row. This process is repeated until suitable values are
entered in the board. Once a game is complete, meaning the board fills up, the game
automatically detects this and ends the game. Once a game ends you are congratulated
and asked if you wish to save your board. The procedure for saving is the same as
described above. Then you are asked if you wish to play again. Clicking ‘Y’ for yes will
relaunch the entire game. Clicking no will quit with an exception.

## Data Representation

The Jigsaw Sudoku was represented using a very simple data structure. Essentially a
Board is composed of a list of Cells. Each Cell is a tuple of type: (Char, Char, Int, Int).
The first two Char values represent the block value (or the value of the jigsaw piece)
followed by the actual filled in sudoku value of that coordinate. The two Int values are
the row value followed by the column value.
Error Checking
The error checking for cell additions to the sudoku board does a few checks on the
value. First, the row, column and number values are checked to be within the correct
range of acceptable values. Then the number value is checked to confirm that this
number does not already lie on the same row. This check is repeated to check it does
not lie in the same column or the same block. Then the game checks that the cell the
user wants to enter a new number is not occupied.
