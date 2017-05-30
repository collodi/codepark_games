def deploy(w, h)
  [[0, 0, 'V'], [0, 2, 'V'], [0, 4, 'V'], [0, 6, 'V'], [0, 8, 'V'], [9, 0, 'H'], [9, 4, 'H'], [9, 6, 'H'], [9, 9, 'H'], [4, 8, 'H']]
end

def play(board, attacks, lastmove, sunk)
  attacks[0].length.times do |c|
    attacks.length.times do |r|
      return [r, c] if not attacks[r][c].is_hit
    end
  end

  return nil
end
