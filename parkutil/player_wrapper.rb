require 'timeout'
require 'shikashi'
require_relative 'sandbox'

module Parkutil

  class PlayerWrapper
    attr_reader :uid
    attr_accessor :timeout_sec

    def initialize(f, uid, reg_funcs)
      @uid = uid
      @timeout_sec = 1

      m_name = f.basename('.rb').to_s.split('_').map(&:capitalize).join
      @sandbox = Shikashi::Sandbox.new
      @sandbox.run(Sandbox.priv, "module #{m_name}\n#{File.open(f, 'rb').read}\nend")

      m = @sandbox.base_namespace.const_get m_name
      reg_funcs.each do |func, argc|
        # has function?
        raise IncompleteImplementation.new("You do not have a required function '#{func}'") if not m.method_defined? func
        # check number of parameters
        raise MismatchingFunctionSignature, "Your function '#{func}' should have #{argc} argumens" if m.instance_method(func).arity != argc
      end

      to_extend = Module.new do
        include m

        m.instance_methods.each do |func|
          define_method(func) do |*args, &blk|
            Timeout::timeout(@timeout_sec, Parkutil::ClockTimeout) do
              begin
                super(*args, &blk)
              rescue SecurityError => e
                ln, fn = e.backtrace[2].split(':')[1..-1]
                raise PermissionDenied.new(e.message, ln, fn)
              end
            end
          end
        end
      end

      extend to_extend
    end

  end
end
