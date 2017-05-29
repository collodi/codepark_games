module Battleship

  class Block
    attr_reader :r, :c
    attr_accessor :is_occupied, :is_hit

    def initialize(r, c)
      @r, @c = r, c
      @is_occupied = false
      @is_hit = false
    end

    def offset_by(r, c)
      return Block.new(@r + r, @c + c)
    end

    def with_in?(b1, b2)
      @r.between?(b1.r, b2.r) and @c.between?(b1.c, b2.c)
    end

    def hide_cp
      c = self.dup
      c.is_occupied = nil
      return c
    end
  end

end
