class Array

  def my_uniq
    unique_array = []
    self.each do |num|
      unique_array << num unless unique_array.include?(num)
    end
    unique_array
  end

  def two_sum
    two_sums = []
    self.each_with_index do |num, i|
      (i + 1.. self.length - 1).each do |j|
        two_sums << [i, j] if self[i] + self[j] == 0
      end
    end

    two_sums
  end

end

class TowersOfHanoi
  attr_accessor :piles

  def initialize
    @piles = [ [1, 2, 3], [], [] ]
  end

  def move_disk(from, to)
    raise ArgumentError.new if piles[from].empty?
    if !piles[to].empty? && piles[to].first < piles[from].first
      raise ArgumentError.new
    end
    piles[to].unshift(piles[from].shift)
  end

  def win?
    piles.last == [1, 2, 3]
  end

end


def my_transpose(matrix)

  new_matrix = []
  (0...matrix.size).each do |i|
    sub_arr = []
    matrix.each do |row|
      sub_arr << row[i]
    end
    new_matrix << sub_arr
  end

  new_matrix
end


def stock_picker(stocks)
  biggest_gap = 0
  stock_days = []
  stocks.each_index do |i|
    (i...stocks.length).each do |j|
        if stocks[j] - stocks[i] > biggest_gap
          biggest_gap = stocks[j] - stocks[i]
          stock_days = [i, j]
        end
    end
  end
  stock_days
end
