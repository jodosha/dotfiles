# Based on https://github.com/Soliah/dotfiles
begin
  require 'awesome_print'
  AwesomePrint.pry!
rescue LoadError
end

if defined?(PryByebug)
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
end
