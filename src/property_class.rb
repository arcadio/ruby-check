require 'forwardable'


class Property
  extend SingleForwardable

  def self.pp; @@pp ||= {} end

  def_delegators :pp, :[], :[]=, :has_key?, :clear

  def self.method_missing(name, *args)
    if pp.has_key?(name)
      narg = args.size
      arity = pp[name].arity
      if narg != arity
        raise ArgumentError, "wrong number of arguments (#{narg} for #{arity})"
      end
      pp[name].pred.call(*args)
    else
      super
    end
  end

  def self.respond_to?(name, include_private = false)
    pp.has_key?(name) ? true : super
  end
end
