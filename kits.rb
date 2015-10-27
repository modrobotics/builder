require "C:/cygwin64/home/shmee_000/builder/constants.rb"
autoload :Builder, "#{BUILDER_DIRECTORY}/builder.rb"
require "#{BUILDER_DIRECTORY}/types_kits.rb"

Builder.build(TYPES, true)
