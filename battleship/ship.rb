module Battleship

  class Ship
    attr_reader :sunk, :l

    def initialize(ship, len)
      r, c, o = ship

      @l = len
      @orient = (o == 'H')

      @s = Block.new(r, c)
      if @orient then
        @e = @s.offset_by(0, len - 1)
      else
        @e = @s.offset_by(len - 1, 0)
      end

      @hits = 0
      @sunk = false
    end

    def fits?(dim)
      @s.with_in?(*dim) and @e.with_in?(*dim)
    end

    def hit?(b)
      return false if @sunk or not b.with_in?(@s, @e)

      @hits += 1
      @sunk = true if @hits == @l
      return true
    end

    def blocks
      (@s.r..@e.r).cycle.take(@l).zip (@s.c..@e.c).cycle
    end
  end

end
