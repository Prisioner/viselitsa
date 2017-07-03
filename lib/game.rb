class Game
  attr_reader :letters, :good_letters, :bad_letters, :status, :errors
  ERRORS_LIMIT = 7

  def initialize(slovo)
    @letters = get_letters(slovo)
    @errors = 0
    @good_letters = []
    @bad_letters = []
    @status = 0
  end

  def get_letters(slovo)
    if (slovo == nil || slovo == "")
      puts "Вы не ввели слово для игры"
      exit
    end
    slovo.upcase.split("")
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

  # Метод проверяет наличие буквы в загаданном слове
  def good_letter?(bukva)
    case bukva
      when "Е","Ё"
        ["Е","Ё"].any?{ |letter| @letters.include?(letter) }
      when "И","Й"
        ["И","Й"].any?{ |letter| @letters.include?(letter) }
      else
        @letters.include?(bukva)
    end
  end

  # Добавляем букву в массив
  def add_letter(bukva, some_letters)
    case bukva
      when "Е","Ё"
        some_letters << "Е"
        some_letters << "Ё"
      when "И","Й"
        some_letters << "И"
        some_letters << "Й"
      else
        some_letters << bukva
    end
  end

  # Проверяет, не повторяется ли буква с уже названными
  def repeated?(bukva)
    @good_letters.include?(bukva) || @bad_letters.include?(bukva)
  end

  def win?
    (@letters - @good_letters).empty?
  end

  def lose?
    @errors >= ERRORS_LIMIT
  end

  def atempts
    ERRORS_LIMIT - @errors
  end

  def next_step(bukva)
    return if @status == -1 || @status == 1
    return if repeated?(bukva)
    if good_letter?(bukva)
      add_letter(bukva, @good_letters)
      @status = 1 if win?
    else
      add_letter(bukva, @bad_letters)
      @errors += 1
      @status = -1 if lose?
    end
  end
end
