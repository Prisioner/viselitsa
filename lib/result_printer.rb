class ResultPrinter
  # Задаём значение плейсхолдера для отсутствующих изображений
  DEFAULT_STATUS_IMAGE = "\n [ Здесь могла быть картинка, но её украли рептилоиды ]\n\n"

  def initialize
    @status_image = Hash.new(DEFAULT_STATUS_IMAGE)

    images_path = File.dirname(__FILE__) + "/../image/"
    images = Dir.new(images_path)

    # Считываем все файлы вида <цифра>.txt
    # ResultPrinter не должен знать, сколько их
    images.entries.each do |file_name|
      if file_name =~ /(\d+)(\.txt)/
        # Индекс нашего изображение - цифра из названия файла
        key = Regexp.last_match[1].to_i
        # Мы идём в цикле по файлам, которые есть в директории, File.exists? не нужен
        begin
          @status_image[key] = File.readlines(images_path + file_name, "r:UTF-8")
        rescue SystemCallError
          @status_image[key] = DEFAULT_STATUS_IMAGE
        end
      end
    end

    images.close
  end

  def print_status(game)
    cls
    puts game.version

    puts "\nСлово: #{get_word_for_print(game.letters, game.good_letters)}"

    puts "Ошибки (#{game.errors}): #{game.bad_letters.join(", ")}"

    print_viselitsa(game.errors)

    if game.lost?
      puts "Вы проиграли :("
      puts "Загаданное слово: #{game.letters.join('')}"
    elsif game.won?
      puts "Поздравляем! Вы выиграли!\n\n"
    else
      puts "У вас осталось ещё " \
           "#{sklonenie(game.atempts_left, "попытка", "попытки", "попыток", true)}"
    end
  end

  # Склонение (для количества попыток)
  def sklonenie(number, odin, dva, mnogo, with_number = false)
    prefix = with_number ? "#{number} " : ""

    number = number.to_i

    # Берём остаток от деления на 100
    ostatok = number % 100
    # Если мы попали в 20..99 - нас интересует только последняя цифра
    ostatok = ostatok % 10 if ostatok > 20

    case ostatok
    when 1 then "#{prefix}#{odin}"
    when 2..4 then "#{prefix}#{dva}"
    else
      "#{prefix}#{mnogo}"
    end
  end

  def get_word_for_print(letters, good_letters)
    letters.map { |letter| good_letters.include?(letter) ? letter : "__" }.join(" ")
  end

  def cls
    system "clear" or system "cls"
  end

  def print_viselitsa(errors)
    puts @status_image[errors]
  end
end
