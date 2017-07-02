require_relative 'parkutil'
require_relative 'connect_four'

class ConnectFourRefree

  def initialize(w, h)
    Parkutil.register_function('play', 3)
    Parkutil.load_players(2)

    @board = ConnectFour::Board.new(w, h)
    @logger = Parkutil::GameLogger.new(w, h)
  end

  def start
    while true do
      self.over!
      self.playturn
    end
  end

  def over!
    # check myself if lost
    if @board.gameover? then
      puts Parkutil.player(Parkutil.turn(-1)).uid

      @logger.save
      exit 0
    end

    # draw
    if @board.draw then
      @logger.save
      exit 2
    end
  end

  def playturn
    spot = nil
    begin
      spot = Parkutil.current_player.play(@board.get, @board.last, Parkutil.turn)
    rescue Parkutil::ClockTimeout
    rescue => e
      puts Parkutil.current_player.uid
      Parkutil.print_exception(e)
      exit 1
    end

    @board.play(spot, Parkutil.turn)
    @logger.log(Parkutil.turn, *spot)

    Parkutil.advance_turn
  end

end

ConnectFourRefree.new(7, 6).start
