#! /usr/bin/ruby

require 'gamebase.rb'  # REMOVE THIS LINE BEFORE UPLOADING TO WEB-APP

class Connect4 < GameBase
  # called by GameBase before play starts, so override for game state setup
  # helps avoid lengthy/problematic state setup code in game initialize method
  # initialize your game here
  def before_players_ready
    @state.fill(0,(0..41))
    @next_player = 0
    @min_turn_moves = 0
    @max_turn_moves = 42
  end

  # indexes a GameBase::Vector by default, which will not hold refs to mutable data like arrays & strings
  # return the state of the board cell indexed by (row, col): 1, -1, 0 for player1, player2, empty
  # (0, 0) is the bottom left corner cell
  def index_state(row, col)
    index = row*7 + col
    return nil if row < 0 or col < 0 or row > 5 or col > 6
    @state[index]
  end

  # called by agents, passing in a hash to be filled with {move_id => move_description} pairs
  # treat moves as a hash adding a {move_id => [row, col]} pair for each cell in which the calling agent can go.
  def legal_moves(moves)
    moves.clear if moves.length > 0
    0.upto(41) do |index|
      row = index/7
      col = index%7
      unless @state[index] != 0 or index_state(row - 1,col) == 0
        moves[index] = [row,col]
      end
    end
  end

  # called by agents to execute a move: updates game @state, @next_player, @game_over
  def do_move(move)
    out_of_spaces = true
    val = 0
    val = 1 if @next_player == 0
    val = -1 if @next_player == 1
    @state[move] = val
    @next_player = 1 - @next_player
    @turn_moves += 1

    0.upto(@state.length - 1) do |index|
      row = index/7
      col = index%7
      player = @state[index]
      if (player == 0)
        out_of_spaces = false
        next
      end

      1.upto(3) do |horizontal|
        break unless index_state( row, col + horizontal ) == player
        @game_over = true if(horizontal == 3)
      end
      1.upto(3) do |horizontal|
        break unless index_state( row, col - horizontal ) == player
        @game_over = true if(horizontal == 3)
      end
      1.upto(3) do |vertical|
        break unless index_state( row + vertical, col ) == player
        @game_over = true if(vertical == 3)
      end
      1.upto(3) do |vertical|
        break unless index_state( row - vertical, col ) == player
        @game_over = true if(vertical == 3)
      end
      1.upto(3) do |diagonal|
        break unless index_state( row + diagonal, col + diagonal ) == player
        @game_over = true if(diagonal == 3)
      end
      1.upto(3) do |diagonal|
        break unless index_state( row + diagonal, col - diagonal ) == player
        @game_over = true if(diagonal == 3)
      end
      1.upto(3) do |diagonal|
        break unless index_state( row - diagonal, col - diagonal ) == player
        @game_over = true if(diagonal == 3)
      end
      1.upto(3) do |diagonal|
        break unless index_state( row - diagonal, col + diagonal ) == player
        @game_over = true if(diagonal == 3)
      end
      if @game_over
        puts "WINNING MOVE #{move/7} #{move%7}"
		@winner = player == -1 ? 1 : 0
		return
	  end
    end
    @game_over = out_of_spaces if(!@game_over)
  end

  # last opportunity to execute code, passed Structs for updating with results
  # use Thread.current[:save_game] = obj to persist obj to database
  # this method is fully implemented for you already
  def after_players_shutdown(game_result, *agent_results)
    game_result.result = (@winner ? "player #{@winner + 1} wins" : 'draw')
    @players.length.times do |i|
      win = (i == @winner)
      agent_results[i].result = @winner ? (win ? 'win' : 'loss') : 'draw'
      agent_results[i].won_game_bool = win
    end
    Thread.current[:save_game] = @state.dup
  end

  def print_state
    puts "|               |"
    5.downto(0) do |row|
      print "| "
      0.upto(6) do |col|
        state = index_state(row,col)
        print( state == -1 ? "O " : state == 1 ? "X " : "  " )
      end
      print "|\n"
    end
    puts "================="
  end

end

# REMOVE ALL THE FOLLOWING CODE BEFORE UPLOADING TO WEB-APP BUT KEEP FOR LOCAL TESTING
if __FILE__ == $0
  require 'randomplayer.rb'
  require 'c4_simpleton_s14_connor_lirot.rb'
  c4 = Connect4.new([Connect4Simpleton, RandomPlayer])
  c4.play_game
  gr = Thread.current[:result][0]
  e = gr.exception
  if e
    puts [e.class.to_s, e.message, gr.exception_backtrace]
  else
    puts Thread.current[:result].inspect
    board = Thread.current[:save_game]
    # WRITE SOME CODE HERE TO DISPLAY THE FINAL BOARD POSITION FOR TESTING PURPOSES
    c4.print_state
  end
end
