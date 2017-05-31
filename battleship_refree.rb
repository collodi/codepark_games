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
      self.over!
      self.playturn
    end
  end

  def over!
    # draw
    exit 1 if @boards.all? { |b| b.lost } or @boards.all? { |b| b.opp_skipped }

    # check myself if lost
    if @boards[Parkutil.turn].lost then
      puts Parkutil.player(Parkutil.turn(-1)).uid
      exit 0
    end
  end

  def playturn
    m = @boards[Parkutil.turn]
    o = @boards[Parkutil.turn 1]
    h = nil

    begin
      h = Parkutil.current_player.play(m.get, o.hidden, m.last_attacked, o.last_sunk)
    rescue Parkutil::ClockTimeout
    rescue => e
      puts Parkutil.current_player.uid
      Parkutil.print_exception(e)
      exit 2
    end

    o.attack h
    Parkutil.advance_turn
  end

  def deploy(i)
    begin
      ships = Parkutil.player(i).deploy(*@board_dim)
      @boards[i].deploy(ships)
    rescue Parkutil::ClockTimeout
      @boards[i].lost = true
    rescue => e
      puts Parkutil.player(i).uid
      Parkutil.print_exception(e)
      exit 2
    end
  end

end

BattleshipRefree.new(10, 10).start()
