require 'pathname'
require_relative 'exceptions'
require_relative 'player_wrapper'
require_relative 'sandbox'

module Parkutil

  @registered_functions = Hash.new
  @players = []
  @turn = 0

  def self.register_function(name, argc)
    @registered_functions[name] = argc
  end

  def self.register_class(c)
    Sandbox.priv.instances_of(c).allow_all
  end

  def self.load_players(minn, maxn=nil)
    gamename = File.basename($0, '_refree.rb')

    # check min
    raise NotEnoughPlayers, "Need at least #{minn} players to play #{gamename}" if ARGV.length < minn
    # check max
    maxn = minn if maxn.nil?
    raise TooManyPlayers, "Only #{maxn} players can play #{gamename} at once" if ARGV.length > maxn
    # check players home
    raise PlayerHomeNotSet, 'CODEPARK_PLAYERS_HOME environment variable is not set' if not ENV.has_key? 'CODEPARK_PLAYERS_HOME'

    players_home = Pathname.new(ENV['CODEPARK_PLAYERS_HOME'])
    ARGV.each do |uid|
      f = players_home.join(uid, "#{gamename}.rb")
      # check if player exists
      raise PlayerNotFound, "User #{uid} does not have a player for #{gamename}" if not File.exist? f

      p = PlayerWrapper.new(f, uid, @registered_functions)
      @players.push(p)
    end
  end

  def self.count_players
    @players.length
  end

  def self.player(i)
    @players[i % @players.length]
  end

  def self.current_player
    @players[@turn]
  end

  def self.turn(i = 0)
    (@turn + i) % @players.length
  end

  def self.advance_turn
    @turn = self.turn(1)
  end

end
