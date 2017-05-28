require 'parkutil'
require 'battleship'

class Battleship

  def initialize(w, h)
    Parkutil.register_function('deploy', 2)
    Parkutil.register_function('play', 4)
    Parkutil.load_players(2)

    @board_dim = [w, h]
    @boards = Parkutil.count_players.times do |i|
      Battleship::Board(*@board_dim)
    end
  end

  def start
    Parkutil.count_players.times { |i| self.deploy(i) }

    while true do
      r = self.over
      case r
      when 2
        puts 'Game ended in a draw'
        break
      when != -1
        puts "#{Parkutil.players[r].uid} won"
        break
      end

      self.playturn
    end
  end

  def over
    # draws
    return 2 if @boards.all? { |b| b.lost }
    return 2 if @boards.all? { |b| b.opp_skipped }

    # check myself if lost
    return Parkutil.turn if @boards[Parkutil.turn].lost

    # game goes on
    return -1
  end

  def playturn
    m = @boards[Parkutil.turn]
    o = @boards[Parkutil.next_turn]
    h = nil

    begin
      h = Parkutil.current_player.play(m.get, o.hidden, m.last_attacked, o.last_sunk)
    rescue Parkutil::ClockTimeout
    ensure
      o.attack h
      Parkutil.advance_turn
    end
  end

  def deploy(i)
    begin
      ships = Parkutil.players[i].deploy(*@board_dim)
      @boards[i].deploy(ships)
    rescue Parkutil::ClockTimeout
      @boards[i].lost = true
    end
  end

end

Battleship(10, 10).start()
