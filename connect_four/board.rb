module ConnectFour

  class Board
    attr_reader :draw, :last

    def initialize(w, h)
      @w, @h = w, h

      @last = nil
      @first_play = true

      @draw = false
      @piece_cnt = 0
      @piece_max = @w * @h
      @board = h.times.map do |_|
        w.times.map { |_| nil }
      end
    end

    def get
      @board.map(&:clone)
    end

    def contains?(r, c)
      r.between?(0, @h - 1) and c.between?(0, @w - 1)
    end

    def floating?(r, c)
      @board[(r + 1)..-1].any? { |x| x[c].nil? }
    end

    def play(spot, piece)
      if not spot.nil? then
        r, c = spot
        # within the board?
        spot = nil if not self.contains?(r, c)
        # already played? or floating?
        spot = nil if not @board[r][c].nil? or self.floating?(r, c)
      end

      @draw = true if @last.nil? and spot.nil? and not @first_play
      @first_play = false if @first_play

      @last = spot
      return if spot.nil?

      r, c = spot
      @board[r][c] = piece

      @piece_cnt += 1
      draw = true if @piece_cnt == @piece_max # truly true only if gameover? is false
    end

    def gameover?
      return false if @last.nil?
      # only need to check the last move
      return self.lines(@last).any? { |l| self.four? l }
    end

    def lines(spot)
      r, c = spot
      # -, |, \, /
      return [@board[r][0..-1],
              @board[0..-1].map { |r| r[c] },
              self.diagonal(c - r),
              self.diagonal(c + r, true)]
    end

    # \ (default)
    def diagonal(i, reverse=false)
      row_len = @board[0].length - 1
      col_range = if reverse then ((i - row_len)..i).reverse_each else (i..(i + row_len)) end

      spots = (0...@board.length).zip col_range
      return spots.map do |r, c|
        next if not c.between?(0, row_len)
        @board[r][c]
      end
    end

    def four?(ln)
      ln.chunk_while { |a, b| a == b }.each do |c|
        next if c[0].nil?
        return true if c.length == 4
      end
      return false
    end

  end

end
