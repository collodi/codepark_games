module Battleship

  class Board
    attr_reader :opp_skipped, :last_attacked, :last_sunk
    attr_accessor :lost

    def initialize(w, h)
      @dim = [Block.new(0, 0), Block.new(h - 1, w - 1)]
      @lost = false

      @ships = []
      @shiplens = [4, 3, 3, 2, 2, 2, 1, 1, 1, 1]

      @last_attacked = nil
      @last_sunk = 0

      @opp_skipped = false
      @board = h.times.map do |i|
        w.times.map { |j| Block.new(i, j) }
      end
    end

    def deploy(ships)
      # check number of ships
      @lost = true if ships.length != @shiplens.length

      # check if ships fits in the board
      ships.each_index do |i|
        s = Ship.new(ships[i], @shiplens[i])
        if s.fits? @dim then
          @ships.push(s)
          # check overlap & occupy board
          s.blocks.each do |r, c|
            if @board[r][c].is_occupied then
              @lost = True
              return
            end

            @board[r][c].is_occupied = true
          end
        else
          @lost = true
          return
        end
      end
    end

    def get
      @board.map do |r|
        r.map { |b| b.dup }
      end
    end

    def hidden
      @board.map do |r|
        r.map { |b| b.hide_cp }
      end
    end

    def attack(h)
      @last_sunk = 0
      @last_attacked = h
      # player skipped
      if h == nil then
        @opp_skipped = true
        return
      end

      # inside the board? && not yet hit?
      b = @board[h[0]][h[1]]
      if not b.with_in?(*@dim) or b.is_hit then
        @last_attacked = nil
        @opp_skipped = true
        return
      end

      b.is_hit = true
      @opp_skipped = false
      # check if it hit a ship
      @ships.each do |s|
        if s.hit?(b) then
          @last_sunk = s.l if s.sunk
          break
        end
      end

      # check if lost
      self.lost = true if @ships.all? { |s| s.sunk }
    end
  end

end
