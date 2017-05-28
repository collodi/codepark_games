module Parkutil

  class PlayerWrapper
    attr_reader :uid
    attr_accessor :timeout_sec

    def initialize(f, uid)
      require f
      extend Battleship # TODO has to be variable

      @uid = uid
      @timeout_sec = 1
    end

    # TODO override method calls (timer, sandbox)
  end

end
