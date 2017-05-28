module Battleship

  class Block
    def initialize(r, c)
      @r, @c = r, c
      @is_occupied = false
      @is_hit = false
    end

    def offset_by(r, c)
      return Block(@r + r, @c + c)
    end

    def with_in?(b1, b2)
      (b1.r <= @r <= b2.r) and (b1.c <= @c <= b2.c)
    end

    def hide_cp
      c = self.dup
      c.is_occupied = nil
      return c
    end
