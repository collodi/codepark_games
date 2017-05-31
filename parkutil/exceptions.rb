module Parkutil

  class CodeparkError < StandardError
    def initialize(msg, line = nil, func = nil)
      @msg = msg
      @line = line
      @func = func
    end

    def message
      @msg
    end

    def backtrace
      return [] if @func.nil?
      return ["line #{@line}: #{@func}"]
    end
  end

  class PermissionDenied < CodeparkError; end
  class ClockTimeout < CodeparkError; end

  class NotEnoughPlayers < CodeparkError; end
  class TooManyPlayers < CodeparkError; end
  class PlayerHomeNotSet < CodeparkError; end
  class PlayerNotFound < CodeparkError; end
  class IncompleteImplementation < CodeparkError; end
  class MismatchingFunctionSignature < CodeparkError; end

end
