module Battleship

  class Ship
    def initialize(ship, len)
      r, c, o = ship

      @l = len
      @orient = (o == 'H')

      @s = Block(r, c)
      if @orient then
        @e = @s.offset_by(0, len - 1)
      else
        @e = @s.offset_by(len - 1, 0)
      end

      @hits = 0
      @sunk = false
    end

    def fits?(dim)
      @s.with_in(*dim) and @e.with_in(*dim)
    end

    def hit?(b)
      return false if @is_sunk or not b.with_in(@s, @e)

      @hits += 1
      @sunk = true if @hits == @l
      return true
    end

    def blocks
      (@s[0]..@e[0]).cycle.take(@l).zip @s[1]..@e[1]
    end
  end

end
