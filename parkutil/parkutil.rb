module Parkutil

  class Parkutil
    def initialize
      @registered_functions = Hash.new
    end

    def register_function(name, argc)
      @registered_functions[name] = argc
    end

    def get_players(minn, maxn=nil)
      gamename = ARGV[0][0..-('_refree.rb'.length)]

      # check min
      raise NotEnoughPlayers("Need at least #{minn} players to play #{gamename}") if ARGV.length - 1 < minn
      # check max
      maxn = minn if maxn.nil?
      raise TooManyPlayers("Only #{maxn} players can play #{gamename} at once") if ARGV.length - 1 > maxn
      # check players home
      players_home = ENV['CODEPARK_PLAYERS_HOME']
      raise PlayerHomeNotSet('CODEPARK_PLAYERS_HOME environment variable is not set')

      players = []
      ARGV[1..-1].each do |uid|
        f = File.pathname(players_home).join("#{uid}/#{gamename}.rb")
        # check if player exists
        raise PlayerNotFound("User #{uid} does not have a player for #{gamename}") if not File.exist? f

        p = require f # TODO
        players.push(p)

        @registered_functions.each do |func, argc|
          # has function?
          raise IncompleteImplementation("User #{uid} does not have a required function #{func}") if not p.method_defined? func
          # check number of parameters
          raise MismatchingFunctionSignature("User #{uid}'s function #{func} should have #{argc} argumens") if p.method(func).arity != argc
        end
      end

      return players
    end
  end

end
