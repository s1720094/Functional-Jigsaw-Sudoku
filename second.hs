import System.IO
import System.Exit
import Control.Monad
import Control.Exception
import Data.Char

-- Cell is (Block value, Number, Row, Column)
type Cell = (Char, Char, Int, Int)
type Board = [Cell]

-- Retrieve cell value from cell tuple
getVal :: (Char, Char, Int, Int) -> Char
getVal (_, a, _, _) = a

-- Retrieve block value from cell tuple
getBlock :: (Char, Char, Int, Int) -> Char
getBlock (a, _, _, _) = a

--
fillBoard :: [String] -> [String] -> Int -> Int -> Board
fillBoard ([]) ([]) r c = []
fillBoard (l:ls) (z:zs) r c = fillRow l z r c ++ fillBoard ls zs (r+1) c
  where
    fillRow (l:[]) (z:[]) r c = (l, z, r, c) : []
    fillRow (l:ls) (z:zs) r c = (l, z, r, c) : fillRow ls zs r (c+1)

-- Print out board to console
printBoard :: Board -> IO ()
printBoard board = putStrLn $ foldr (++) "" [if c == 8 then a : "\n" else a : "" | (b,a,r,c) <- board]

-- print Board with Horizontal divisions
printBoard2 :: Board -> IO ()
printBoard2 board = putStrLn $ foldr (++) "" (map (\((b1,a1,r1,c1),(b2,a2,r2,c2)) -> if (c1 == 8) then a1 :"\n" else if (b1 /= b2) then a1 : "|" else a1 : " ") c)
  where
    z = board ++ [('d','d',1,1)]
    c = zip board (tail z)


--Error handling when making a move
checkBoard :: Int -> Int -> Char-> Board -> Bool
checkBoard r c n board = checkValue r c n && checkBlock r c n board && checkRow r n board
  && checkColumn c n board && checkFree r c board
  where
    -- Check column, row and number values are in range
    checkValue r c n = elem n rangen && elem r range && elem c range
    rangen = ['1','2','3','4','5','6','7','8','9']
    range = [0..8]
    -- Check that number to be added does not exist on row
    checkRow r n board =
      foldl (&&) True $ map (\(_,a,_,_) -> n /= (a)) $ filter (\(_,_,a,_) -> a == r) board
    -- Check that number to be added does not exist on column
    checkColumn c n board =
      foldl (&&) True $ map (\(_,a,_,_) -> n /= (a)) $ filter (\(_,_,_,a) -> a == c) board
    -- Check position to be added is free
    checkFree r c board =
      getVal (head (filter (\(_, _, r1, c1) -> r == r1 && c == c1) board)) == '.'
    -- Check that number to be added does not exist on block
    checkBlock r c n board = foldl (&&) True $ map (\(_,a,_,_) -> n /= (a)) $ filter (\(a,_,_,_) -> a == blockVal) board
      where
        blockVal = getBlock (head (filter (\(_, _, r1, c1) -> r == r1 && c == c1) board))

-- Generate new board with new move addition
moveBoard :: Int -> Int -> Char -> Board -> Board
moveBoard r c n board = map(\(a,b,c1,d) -> if c1 == r && d == c then (a,n,c,d) else (a,b,c1,d)) board

-- Handle incorrect file input error
showError :: SomeException -> IO String
showError _ = do
   putStrLn("Sorry, there is no board file with that name!")
   putStrLn("Would you like to try again? (Y/N)")
   again <- getLine
   if again == "Y" then load else quitB
   return ("")

showError2 :: Board -> SomeException -> IO ()
showError2 board _ = do
  putStrLn("Sorry, there is no board file with that name!")
  putStrLn("Would you like to try again? (Y/N)")
  again <- getLine
  if again == "Y" then save board else quit board
  return ()

inputError :: Board -> SomeException -> IO Int
inputError board _ = do
  putStrLn ("Would you like to save your board? (Y/N)")
  saveF <- getLine
  when (saveF == "Y") $ save (board)
  putStrLn ("Thanks for playing!")
  exitWith ExitSuccess
  return (-1)


-- Load board from text file
load :: IO (Board)
load = do
  putStrLn "Enter the name of the board you would like to load (with .txt)"
  file <- getLine
  contents <- catch (readFile file) showError
  let board = lines contents
  let layout = take 9 board
  let fill   = drop 9 board
  return $ fillBoard layout fill 0 0

save :: Board -> IO ()
save board = do
  let newContents = foldr (++) "" [if c == 8 then b : "\n" else b : "" | (b,a,r,c) <- board] ++ foldr (++) "" [if c == 8 then a : "\n" else a : "" | (b,a,r,c) <- board]
  putStrLn "Enter the name of the board you would like to write to (with .txt)"
  file <- getLine
  contents <- catch (writeFile file newContents) (showError2 board)
  putStrLn ("Succesfully saved file!")
  return ()


-- Place new number on board given it satisfies the constraints
move :: Board -> IO (Board)
move board = do
  putStrLn "Next move: "
  putStr "Row: "
  row <- catch (readLn :: IO Int) (inputError board)
  putStr "Column: "
  column <- catch (readLn :: IO Int) (inputError board)
  putStr "Number: "
  number <- catch (readLn :: IO Int) (inputError board) -- :: IO Char
  if checkBoard row column (intToDigit number) board then
    return $ moveBoard row column (intToDigit number) board
  else
    do
      putStrLn "Sorry, there is a conflict existing in your board"
      putStrLn "Would you like to try again? (Y/N)"
      again <- getLine
      if again == "Y" then move board else quitB

-- Quit Sudoku game with Board IO
quitB :: IO (Board)
quitB = do
  putStrLn ("Thanks for playing!")
  exitWith ExitSuccess
  return []

-- Quit Sudoku game with blank IO
quit :: Board -> IO ()
quit board = do
  putStrLn ("Would you like to save your board? (Y/N)")
  saveF <- getLine
  when (saveF == "Y") $ save (board)
  putStrLn ("Thanks for playing!")
  exitWith ExitSuccess
  return ()

quitG :: IO ()
quitG = do
  putStrLn ("Thanks for playing!")
  exitWith ExitSuccess
  return ()

checkComplete :: Board -> Bool
checkComplete board = foldr (&&) True [a /= '.' | (b,a,r,c) <- board]

-- Main playing loop of making move, printing board then checking for completion of board
mainLoop :: Board -> IO ()
mainLoop board =
  if checkComplete board
    then
      do
        putStrLn "The board is complete! You win!"
        putStrLn ("Would you like to save your board? (Y/N)")
        saveF <- getLine
        when (saveF == "Y") $ save (board)
        putStrLn "Would you like to play again? (Y/N)"
        again <- getLine
        if again == "Y" then main else quitG
    else
      do
        newBoard <- move board
        putStrLn "\nNew board: \n"
        printBoard2 newBoard
        mainLoop newBoard

main :: IO ()
main = do
  putStrLn "\nWelcome to Jigsaw Sudoku! \n"
  board <- load
  printBoard2 board
  mainLoop board
  putStrLn ""
