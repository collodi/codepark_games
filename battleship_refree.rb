require_relative 'parkutil'
require_relative 'battleship'

class BattleshipRefree

  def initialize(w, h)
    Parkutil.register_class(Battleship::Block)
    Parkutil.register_function('deploy', 2)
    Parkutil.register_function('play', 4)
    Parkutil.load_players(2)

    @board_dim = [w, h]
    @boards = Parkutil.count_players.times.map do |i|
      Battleship::Board.new(*@board_dim)
    end
  end

  def start
    Parkutil.count_players.times { |i| self.deploy(i) }

    while true do
      r = self.over
      if r == -2 then
        puts 'DRAW'
        break
      elsif r != -1 then
        puts Parkutil.player(r).uid
        break
      end

      self.playturn
    end
  end

  def over
    # draws
    return -2 if @boards.all? { |b| b.lost }
    return -2 if @boards.all? { |b| b.opp_skipped }

    # check myself if lost
    return Parkutil.turn(-1) if @boards[Parkutil.turn].lost

    # game goes on
    return -1
  end

  def playturn
    m = @boards[Parkutil.turn]
    o = @boards[Parkutil.turn 1]
    h = nil

    begin
      h = Parkutil.current_player.play(m.get, o.hidden, m.last_attacked, o.last_sunk)
    rescue Parkutil::ClockTimeout
    rescue Parkutil::PermissionDenied
    ensure
      o.attack h
      Parkutil.advance_turn
    end
  end

  def deploy(i)
    begin
      ships = Parkutil.player(i).deploy(*@board_dim)
      @boards[i].deploy(ships)
    rescue Parkutil::PermissionDenied
      @boards[i].lost = true
    rescue Parkutil::ClockTimeout
      @boards[i].lost = true
    end
  end

end

BattleshipRefree.new(10, 10).start()
