require 'agentbase.rb'

class RandomPlayer < AgentBase
  def take_turn(reward=nil, is_terminal=false)
    @game.legal_moves(moves = Hash.new)
	move = moves.keys.choice
    @game.do_move(move)
  end
end
