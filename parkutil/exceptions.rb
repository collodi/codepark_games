module Parkutil

  class PermissionDenied < StandardError; end
  class ClockTimeout < StandardError; end
  class NotEnoughPlayers < StandardError; end
  class TooManyPlayers < StandardError; end
  class PlayerHomeNotSet < StandardError; end
  class PlayerNotFound < StandardError; end
  class IncompleteImplementation < StandardError; end
  class MismatchingFunctionSignature < StandardError; end

end
