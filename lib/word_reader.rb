class WordReader
  def read_from_file(file_name)
    begin
      f = File.new(file_name, 'r:UTF-8')
    rescue SystemCallError
      puts "Файл со словами отсутствует"
      exit
    end
    lines = f.readlines
    f.close
    lines.sample.chomp
  end
end
