module Parkutil

  class PlayerWrapper
    attr_reader :uid
    attr_accessor :timeout_sec

    def initialize(f, uid)
      module_name = f.basename('.rb').to_s.split('_').map(&:capitalize).join

      require f
      extend Object.const_get(module_name)

      @uid = uid
      @timeout_sec = 1
    end

    # TODO override method calls (timer, sandbox)
  end

end
