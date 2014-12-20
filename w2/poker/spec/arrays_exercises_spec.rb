require 'rspec'
require 'arrays.rb'

describe "my_uniq" do
  it "takes an empty array" do
    expect([].my_uniq).to eq([])
  end

  it "finds uniques" do
    expect([1, 2, 1, 3, 3].my_uniq).to eq([1, 2, 3])
  end

  it "returns the array when they're all unique" do
    expect([1, 2, 3].my_uniq).to eq([1, 2, 3])
  end
end

describe "two_sum" do
  it "takes an empty array" do
    expect([].two_sum).to eq([])
  end

  it "finds two-sums" do
    expect([-1, 0, 2, -2, 1].two_sum).to eq([[0, 4], [2, 3]])
  end

  it "takes an array with no two-sums" do
    expect([-1, 0, 2].two_sum).to eq([])
  end

  it "finds more than one sum of the same number" do
    expect([-1, 0, 1, 1].two_sum). to eq([[0,2], [0, 3]])
  end
end

describe "TowersOfHanoi" do
  subject(:tower) { TowersOfHanoi.new }
  it "has one array with three disks and two empty disks" do
    expect(tower.piles).to eq([ [1, 2, 3], [], [] ])
  end

  it "moves disk" do
    tower.move_disk(0, 1)
    expect(tower.piles).to eq([ [2, 3], [1], [] ] )
  end

  it "raises error when starting pile is empty" do
    expect do
      tower.move_disk(1,2)
    end.to raise_error(ArgumentError)
  end

  it "raises error when disk is placed on top of smaller disk" do
    tower.move_disk(0, 1)
    expect{tower.move_disk(0, 1)}.to raise_error(ArgumentError)
  end

  it "wins" do
    tower.piles = [[], [1], [2, 3]]
    tower.move_disk(1, 2)
    expect(tower.win?).to be true
  end

  it "doesn't win when it's not supposed to" do
    expect(tower.win?).to be false
  end
end

describe "my_transpose" do

  it "flips an array" do
    expect(my_transpose([[0, 1, 2], [3, 4, 5], [6, 7, 8]])).to eq([[0, 3, 6], [1, 4, 7], [2, 5, 8]])
  end

end

describe "stock_picker" do

  it "picks a right pair" do
    expect(stock_picker([ 1, 5, 3, 8, 2 ])).to eq([0, 3])
  end

  it "returns an empty array when there is no profitable pair" do
    expect(stock_picker([8, 5, 4, 2])).to eq([])
  end

  it "picks the first day if there are multiple options" do
    expect(stock_picker([ 1, 5, 3, 8, 2, 8 ])).to eq([0, 3])
  end

end
