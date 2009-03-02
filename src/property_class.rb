require 'forwardable'


class Property
  extend SingleForwardable

  def self.hash; @@pp ||= {} end

  def_delegators :hash, :[], :[]=, :has_key?, :clear

  def self.method_missing(name, *args)
    if hash.has_key?(name)
      narg = args.size
      arity = hash[name].types.size
      if narg != arity
        raise ArgumentError, "wrong number of arguments (#{narg} for #{arity})"
      end
      hash[name].pred.call(*args)
    else
      super
    end
  end

  def self.respond_to?(name, include_private = false)
    hash.has_key?(name) ? true : super
  end
end
