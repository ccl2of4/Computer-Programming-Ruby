#!/usr/bin/ruby

RowCol = Struct.new(:row, :col)
Direction = Struct.new(:x,:y)

class Connect4Simpleton < AgentBase
  def get_ready
    @moves_hash = {}
	@state_copy = nil
    @first_move = nil
    @which_player_am_i = -12
  end
  def take_turn(reward=nil, is_terminal=false)
    move = nil
	@state_copy = @game.dup_state
    @game.legal_moves(@moves_hash)

    if(@first_move.nil?)
      key = @moves_hash.keys.choice
      value = @moves_hash.fetch(key)
      @first_move = RowCol.new(value[0],value[1])
      return @game.do_move(key)
    end

    if(@which_player_am_i == -12)
      @which_player_am_i = @game.index_state(@first_move.row,@first_move.col)
    end
    @moves_hash.keys.each do |key|
      value = @moves_hash.fetch(key)
      row_col = RowCol.new(value[0],value[1])
      result = scan(row_col,Direction.new(0,1))
      if(result > 0)
        if(result > 1)
          return @game.do_move(key)
        end
        move = key
      end
      result = scan(row_col,Direction.new(0,-1))
      if(result > 0)
        if(result > 1)
          return @game.do_move(key)
        end
        move = key
      end
      result = scan(row_col,Direction.new(1,0))
      if(result > 0)
        if(result > 1)
          return @game.do_move(key)
        end
        move = key
      end
      result = scan(row_col,Direction.new(-1,0))
      if(result > 0)
        if(result > 1)
          return @game.do_move(key)
        end
        move = key
      end
      result = scan(row_col,Direction.new(1,1))
      if(result > 0)
        if(result > 1)
          return @game.do_move(key)
        end
        move = key
      end
      result = scan(row_col,Direction.new(1,-1))
      if(result > 0)
        if(result > 1)
          return @game.do_move(key)
        end
        move = key
      end
      result = scan(row_col,Direction.new(-1,1))
      if(result > 0)
        if(result > 1)
          return @game.do_move(key)
        end
        move = key
      end
      result = scan(row_col,Direction.new(-1,-1))
      if(result > 0)
        if(result > 1)
          return @game.do_move(key)
        end
        move = key
      end
    end
    return @game.do_move(@moves_hash.keys.choice) if move.nil?
    @game.do_move(move)
  end
  def index_to_row_col(index)
    RowCol.new(index/7,index%7)
  end
  def scan(row_col,direction)
    scanner = RowCol.new(row_col.row + 3*direction.y,row_col.col + 3*direction.x)
    if scanner.row < 0 or scanner.row > 5 or scanner.col < 0 or scanner.col > 6
        return 0
    end
    player = @game.index_state(scanner.row,scanner.col)
    if player == 0
      return 0
    end
    1.upto(3) do |iteration|
      scanner.row -= direction.y
      scanner.col -= direction.x
      if(iteration == 3)
        return 2 if player == @which_player_am_i
        return 1
      end
      if @game.index_state(scanner.row,scanner.col) != player
        return 0
      end
    end
  end
end
