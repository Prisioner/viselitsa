class ResultPrinter
  def initialize
    # Задаём значение по умолчанию
    default_status_image = "\n [ Здесь могла быть картинка, но её украли рептилоиды ]\n\n"
    @status_image = Hash.new(default_status_image)

    images_path = File.dirname(__FILE__) + "/../image/"
    images = Dir.new(images_path)

    # Считываем все файлы вида <цифра>.txt
    # ResultPrinter не должен знать, сколько их
    images.entries.each do |file_name|
      if file_name =~ /(\d+)(\.txt)/
        # Индекс нашего изображение - цифра из названия файла
        key = Regexp.last_match[1]
        # Мы идём в цикле по файлам, которые есть в директории, File.exists? не нужен
        begin
          file = File.new(images_path + file_name, "r:UTF-8")
          @status_image[key] = file.read
          file.close
        rescue SystemCallError
          @status_image[key] = default_status_image
        end
      end
    end

    images.close
  end

  def print_status(game)
    cls
    puts "\nСлово: " + get_word_for_print(game.letters, game.good_letters)

    puts "Ошибки (#{game.errors}): #{game.bad_letters.join(", ")}"

    print_viselitsa(game.errors)

    if game.lose?
      puts "Вы проиграли :("
      puts "Загаданное слово: #{game.letters.join('')}"
    else
      if game.win?
        puts "Поздравляем! Вы выиграли!\n\n"
      else
        puts "У вас осталось ещё #{sklonenie(game.atempts, "попытка", "попытки", "попыток", true)}"
      end
    end
  end

  # Метод "склонение" :)
  def sklonenie(number, odin, dva, mnogo, with_number = false)
    if with_number
      prefix = "#{number} "
    else
      prefix = ""
    end

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
    result = ""

    letters.each do |letter|
      if good_letters.include? letter
        result += letter + " "
      else
        result += "__ "
      end
    end

    return result
  end

  def cls
    system "clear" or system "cls"
  end

  def print_viselitsa(errors)
    puts @status_image[errors.to_s]
  end
end
