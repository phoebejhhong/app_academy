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

  def run(source, target)
    @all_seen_words = { source=>nil }
    @current_words = [source]
    until @current_words.empty?
      @new_current_words = []
      @current_words.each do |current_word|
        explore_current_word(current_word)
        @current_words = @new_current_words
      end
    end
    build_path(source, target)
  end

  def explore_current_word(current_word)
    adjecent_words(current_word).each do |adj_word|
      next if @all_seen_words.include?(adj_word)
      @new_current_words << adj_word
      @all_seen_words[adj_word] = current_word
    end
  end

  def build_path(source, target)
    path = []
    prev_word = @all_seen_words[target]
    until prev_word.nil?
      path << prev_word.dup
      prev_word = @all_seen_words[prev_word]
    end
    path.reverse << target

  end


end

wc = WordChainer.new('dictionary.txt')
p wc.run('in', 'to')
