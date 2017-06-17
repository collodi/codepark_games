require 'shikashi'

module Sandbox

  def self.priv
    @@priv
  end

  @@priv = Shikashi::Privileges.new

  @@priv.instances_of(Array).allow_all
  @@priv.instances_of(Queue).allow_all
  @@priv.instances_of(Hash).allow_all
  @@priv.instances_of(String).allow_all
  @@priv.instances_of(Struct).allow_all

  @@priv.instances_of(TrueClass).allow_all
  @@priv.instances_of(FalseClass).allow_all

  @@priv.instances_of(Enumerable).allow_all
  @@priv.instances_of(Enumerator).allow_all

  @@priv.instances_of(Math).allow_all
  @@priv.instances_of(Float).allow_all
  @@priv.instances_of(Integer).allow_all
  @@priv.instances_of(Fixnum).allow_all
  @@priv.instances_of(Bignum).allow_all
  @@priv.instances_of(Rational).allow_all
  @@priv.instances_of(Numeric).allow_all
  @@priv.instances_of(Range).allow_all
  @@priv.instances_of(Random).allow_all

  @@priv.instances_of(Time).allow_all
  @@priv.instances_of(Regexp).allow_all
  @@priv.instances_of(NilClass).allow_all
  @@priv.instances_of(StopIteration).allow_all

  @@priv.allow_method :module_function
end
