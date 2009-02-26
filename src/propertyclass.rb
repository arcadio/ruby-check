class Property
  @@pp = {}

  def self.reset
    @@pp = {}
  end

  def self.method_missing(name, *args, &block)
    if @@pp.has_key?(name)
      as = args.size
      arity = @@pp[name].arity
      if as != arity
        raise ArgumentError, "wrong number of arguments (#{as} for #{arity})"
      end
      @@pp[name].pred.call(*args)
    else
      super
    end
  end

  def self.respond_to?(name, include_private = false)
    @@pp.has_key?(name) ? true : super
  end
end
