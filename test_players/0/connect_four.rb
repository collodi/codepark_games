def play(board, opp_last, piece)
  board[0].each_index do |c|
#    board.each_index.reverse_each do |r|
    return [piece, c] if board[piece][c].nil?
#    end
  end
  return nil
end
