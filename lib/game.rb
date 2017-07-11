class Game
  attr_reader :letters, :good_letters, :bad_letters, :status, :errors
  attr_accessor :version
  ERRORS_LIMIT = 7

  def initialize(word)
    @letters = get_letters(word)
    @errors = 0
    @good_letters = []
    @bad_letters = []

    # :in_progress - игра в процессе
    # :won - победа
    # :lost - поражение
    @status = :in_progress
  end

  def get_letters(word)
    if word.nil? || word == ""
      puts "Вы не ввели слово для игры"
      exit
    end
    word.upcase.split("")
  end

  # 1. спросить букву с консоли
  # 2. проверить результат
  def ask_next_letter
    puts "\n Введите следующую букву:"
    letter = ""
    while letter == "" do
      letter = STDIN.gets.chomp.upcase
    end
    next_step(letter)
  end

  def next_step(letter)
    return unless in_progress?
    return if repeated?(letter)
    if good_letter?(letter)
      add_letter(letter, @good_letters)
      @status = :won if won?
    else
      add_letter(letter, @bad_letters)
      @errors += 1
      @status = :lost if lost?
    end
  end

  def in_progress?
    @status == :in_progress
  end

  # Проверяет, не повторяется ли буква с уже названными
  def repeated?(letter)
    @good_letters.include?(letter) || @bad_letters.include?(letter)
  end

  # Метод проверяет наличие буквы в загаданном слове
  def good_letter?(letter)
    case letter
      when "Е","Ё"
        ["Е","Ё"].any?{ |letter| @letters.include?(letter) }
      when "И","Й"
        ["И","Й"].any?{ |letter| @letters.include?(letter) }
      else
        @letters.include?(letter)
    end
  end

  # Добавляем букву в массив
  def add_letter(letter, some_letters)
    case letter
      when "Е","Ё"
        some_letters << "Е"
        some_letters << "Ё"
      when "И","Й"
        some_letters << "И"
        some_letters << "Й"
      else
        some_letters << letter
    end
  end

  def won?
    @status == :won || (@letters - @good_letters).empty?
  end

  def lost?
    @status == :lost || @errors >= ERRORS_LIMIT
  end

  def atempts_left
    ERRORS_LIMIT - @errors
  end
end
