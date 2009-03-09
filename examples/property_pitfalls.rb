# This file shows some pitfalls that may be encountered when defining
# properties using the framework. The pitfalls only show up on extreme
# cases, and are not exclusive of the tool. They are quirks of Ruby
# blocks, and since all properties are valid Ruby constructs, they
# also apply to the framework.
#
# Moreover, some new syntactic elements of Ruby 1.9 are also
# illustrated. These make the definition of certain properties more
# pleasant.


# Ruby 1.9 compatible
# Special case with new hash syntax
# Fails: needs parentheses, or an array, or a do block
# property a: String { |a| a.size == a.length }

property(a: String) { |a| a.size == a.length }

property a: [String] { |a| a.size == a.length }

property a: String do |a|
  a.size == a.length
end

property a: String do |a| a.size == a.length end


# Ruby 1.9 & 1.8 compatible
# Special case with old hash syntax
# Fails: needs parentheses, or an array, or a do block
# property :a => String { |a| a.size == a.length }

property(:a => String) { |a| a.size == a.length }

# Doesn't work in 1.8
property :a => [String] { |a| a.size == a.length }

property :a => String do |a|
  a.size == a.length
end

property :a => String do |a| a.size == a.length end


# No params
# Fails, needs parentheses, or an array, or a do block
# property :a { 1 > 0 }

# Not compatible with 1.8, uses new syntax
property a: [] { 1 > 0 }

# Doesn't work in 1.8 either
property :a => [] { 1 > 0 }

property :a do
  1 > 0
end

property :a do 1 > 0 end


# Conclusion, all the pitfalls appear in the cases where the curly
# braces notation for blocks is used in combination with a simple
# unparenthesized type declaration. The alternative do end syntax
# never causes problems. Blocks with curly braces are used for single
# statement lambdas by convention, but the do end notation is
# perfectly legal too, so an option is to use this one to avoid all
# sort of problems.
#
# An alternative option if one wants to keep using curly braced blocks
# is to always parenthesize type declarations.
#
# If one choices to ommit parenthesis and use curly braces when
# demanded by the convention, there are only a few extreme cases that
# need special care:
#
# * Ruby 1.9
# ** No type list: property :a { ... }
# ** Type list of size 1 without list delimiters:
#      property a: String { ... }, using 1.9 hash syntax
#        or
#      property :a => String { ... }, using classic hash syntax
#
# Additionally in version 1.8 -which has a less flexible parser- one
# also has to take into account:
# * Ruby 1.8
# ** Type lists of any size: property :a => [String] { ... }
