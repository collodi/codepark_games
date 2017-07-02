require 'json'

module Parkutil

  class GameLogger
    LOGFILE = File.join(ENV['CODEPARK_PLAYERS_HOME'], 'lastgame.logs')

    def initialize(*args)
      File.delete(LOGFILE) if File.exist? LOGFILE
      @logger = [args]
    end

    def log(*args)
      @logger.push args
    end

    def save
      JSON.dump(@logger, File.open(LOGFILE, 'w'))
    end
  end

end
