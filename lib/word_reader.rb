class WordReader
  def self.read_from_file(file_name)
    begin
      File.readlines(file_name, encoding: 'UTF-8').sample.chomp
    rescue SystemCallError
      puts "Файл со словами отсутствует"
      exit
    end
  end
end
