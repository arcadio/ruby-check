require 'forwardable'


class Property
  extend SingleForwardable

  def self.pp; @@pp ||= {} end

  def_delegators :pp, :[], :has_key?, :clear

  def self.method_missing(name, *args)
    if pp.has_key?(name)
      narg = args.size
      arity = pp[name].arity
      if narg != arity
        raise ArgumentError, "wrong number of arguments (#{narg} for #{arity})"
      end
      pp[name].predicate.call(*args)
    else
      super
    end
  end

  def self.respond_to?(name, include_private = false)
    pp.has_key?(name) ? true : super
  end

  @@next_desc = nil

  def self.next_desc=(doc)
    @@next_desc = doc
  end

  attr_reader :desc

  def desc=(doc)
    raise ArgumentError, 'the description must be a String' unless
      doc.is_a?(String)
    raise 'Description already set' unless @desc.nil?
    @desc = doc
  end

  def self.[]=(key, property)
    pp[key] = property
    if @@next_desc
      property.desc = @@next_desc
      @@next_desc = nil
    end
    property
  end
end
