# игра "Виселица" v5.0

# XXX/ Этот код необходим только при использовании русских букв на Windows
if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end
# /XXX

require_relative 'lib/game'
require_relative 'lib/result_printer'
require_relative 'lib/word_reader'

VERSION = "Игра Виселица v5.0"

words_file_name = File.dirname(__FILE__) + "/data/words.txt"

word = WordReader.read_from_file(words_file_name)

game = Game.new(word)
game.version = VERSION

printer = ResultPrinter.new

while game.in_progress? do
  printer.print_status(game)
  game.ask_next_letter
end

printer.print_status(game)
