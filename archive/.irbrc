require "awesome_print"
AwesomePrint.irb!

# returns the instance methods on klass
# that aren't already on Object
def m(klass)
  klass.public_instance_methods - Object.public_instance_methods
end
