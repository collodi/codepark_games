module Parkutil

  @registered_functions = Hash.new
  @players = []
  @turn = 0

  def self.register_function(name, argc)
    @registered_functions[name] = argc
  end

  def self.load_players(minn, maxn=nil)
    gamename = ARGV[0][0..-('_refree.rb'.length)]

    # check min
    raise NotEnoughPlayers("Need at least #{minn} players to play #{gamename}") if ARGV.length - 1 < minn
    # check max
    maxn = minn if maxn.nil?
    raise TooManyPlayers("Only #{maxn} players can play #{gamename} at once") if ARGV.length - 1 > maxn
    # check players home
    players_home = ENV['CODEPARK_PLAYERS_HOME']
    raise PlayerHomeNotSet('CODEPARK_PLAYERS_HOME environment variable is not set')

    ARGV[1..-1].each do |uid|
      f = File.pathname(players_home).join("#{uid}/#{gamename}.rb")
      # check if player exists
      raise PlayerNotFound("User #{uid} does not have a player for #{gamename}") if not File.exist? f

      p = require f # TODO
      @players.push(p)

      @registered_functions.each do |func, argc|
        # has function?
        raise IncompleteImplementation("User #{uid} does not have a required function #{func}") if not p.method_defined? func
        # check number of parameters
        raise MismatchingFunctionSignature("User #{uid}'s function #{func} should have #{argc} argumens") if p.method(func).arity != argc
      end
    end
  end

  def self.count_players
    @players.length
  end

  def self.current_player
    @players[@turn]
  end

  def self.next_turn
    (@turn + 1) % @players.length
  end

  def self.advance_turn
    @turn = self.next_turn
  end

end
