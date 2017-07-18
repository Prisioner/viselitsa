require 'rspec'
require 'game'

describe Game do

  let (:game) { Game.new('КАВАБАНГА') }
  let (:win_letters_set) { %w(К А В Б Н Г) }
  let (:lose_letters_set) { %w(Д Е О Ж З И Ч) }
  let (:cont_letters_set) { %w(К А Д Е О В Б Ж Н З И) }

  it 'game should ends with win' do
    win_letters_set.each { |letter| game.next_step(letter) }
    expect(game.in_progress?).to eq false
    expect(game.won?).to eq true
    expect(game.lost?).to eq false
    expect(game.status).to eq :won
    expect(game.errors).to eq 0
  end

  it 'game should ends with lose' do
    lose_letters_set.each { |letter| game.next_step(letter) }
    expect(game.in_progress?).to eq false
    expect(game.won?).to eq false
    expect(game.lost?).to eq true
    expect(game.status).to eq :lost
    expect(game.errors).to eq 7
  end

  it 'game should continue' do
    cont_letters_set.each { |letter| game.next_step(letter) }
    expect(game.in_progress?).to eq true
    expect(game.won?).to eq false
    expect(game.lost?).to eq false
    expect(game.status).to eq :in_progress
    expect(game.errors).to eq 6
  end
end
