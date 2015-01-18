var TicTacToe = require("./index");

var readline = require('readline');
var reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

var board = new TicTacToe.Board();
var computer = new TicTacToe.Computer(board);
var human = new TicTacToe.Human(reader, board);

var g = new TicTacToe.Game(reader, board, computer, human);

g.run(function(){
  board.print();
  console.log("Good Job");
  reader.close();
});
