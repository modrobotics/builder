require "C:/cygwin64/home/shmee_000/builder/constants.rb"
autoload :Builder, "#{BUILDER_DIRECTORY}/builder.rb"
require "#{BUILDER_DIRECTORY}/types_smt.rb"

Builder.build(TYPES, false)
