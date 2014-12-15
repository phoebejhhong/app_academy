require 'set'

class WordChainer
  attr_accessor :dictionary

  def initialize(dictionary_file_name)
    @dictionary = File.readlines(dictionary_file_name).map(&:chomp).to_set
  end

  def adjecent_words(word)
    adjecent_words = []
    alphas = 'abcdefghigklmnopqrstuvwxyz'.split('')
    word.split('').each_with_index do |letter, idx|
      alphas.each do |alpha|
        next if word[idx] == alpha
        new_word = word.dup
        new_word[idx] = alpha
        adjecent_words << new_word.dup if @dictionary.include?(new_word)
      end
    end
    adjecent_words
  end
end

wc = WordChainer.new('dictionary.txt')
p wc.adjecent_words('word')
