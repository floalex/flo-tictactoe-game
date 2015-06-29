# require 'pry'
# 1. Come up with requirements/sepcifictions, which will determine the scope.
# 2. Application logic: requence of steps
# 3. Translation of those steps into code
# 4. Run code to verify logic.

# How the game works:
# draw a board
# assign player1 to "X"
# assign player2 to "O"

# loop until a winner or all squares are taken
#   player picks an empty square
#   check for a winner
#   computer picks an empty square
#   check for a winner

# if there's a winner
#   show the winner
# else
#   it's a tie

WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], 
                 [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

def initialize_board
  board = {}
  (1..9).each { |position| board[position] = ' '}
  board
end

def empty_positions(board)
  board.keys.select {|position| board[position] == ' ' }
end

def player_places_piece(board)
  begin
    puts "Choose a pisition from (1 - 9) to place a piece:"
    position = gets.chomp.to_i
  end until empty_positions(board).include?(position)
  board[position] = "X"
end

def computer_places_piece(line, board)

  defend_board = nil
  attacked = false

  #attack
  WINNING_LINES.each do |line|
    defend_board = two_in_a_row({line[0]: board[line[0]], 
                                 line[1]: board[line[1]],
                                 line[2]: board[line[2]]}, "O")
    if defend_board
      board[defend_board] = "O"
      attacked = true
      break
    end
  end
  
  #defend
  if attacked == false
    WINNING_LINES.each do |line|
    defend_board = two_in_a_row({line[0]: board[line[0]], 
                                 line[1]: board[line[1]],
                                 line[2]: board[line[2]]}, "X")
      if defend_board
        board[defend_board] = "O"
        break
      end
    end
  end
  board[empty_positions(board).sample] = "O" unless defend_board
end

def two_in_a_row(hsh, mrkr)
  if hsh.values.count(mrkr) == 2
    hsh.select{ |k,v| v == ' '}.keys.first
  else
    false
  end
end

def check_winner(board)
  
  WINNING_LINES.each do |line|
    return 'Player' if board.values_at(*line).count('X') == 3
    return 'Computer' if board.values_at(*line).count('O') == 3
  end
  nil
end

def nine_positions_are_filled?(board)
  empty_positions(board) == []
end

def announce_winner(winner)
  puts "#{winner} won!"
end

def draw_board(board)
  system "clear"
  puts
  puts "    |     |"
  puts "  #{board[1]} |  #{board[2]}  |  #{board[3]} "
  puts "    |     |"
  puts "----+-----+-----"
  puts "    |     |"
  puts "  #{board[4]} |  #{board[5]}  |  #{board[6]} "
  puts "    |     |"
  puts "----+-----+-----"
  puts "    |     |"
  puts "  #{board[7]} |  #{board[8]}  |  #{board[9]} "
  puts "    |     |"
  puts
end

board = initialize_board
draw_board(board)

begin
  player_places_piece(board)
  draw_board(board)
  computer_places_piece(board)
  draw_board(board)
  winner = check_winner(board)
end until winner || nine_positions_are_filled?(board)
if winner
  announce_winner(winner)
else
  puts "It's a tie!"
end