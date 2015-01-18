var board = new Board();
var computer = new Computer(board);
var human = new Human(board);

var g = new Game(board, computer, human);

g.run(function(){
  board.print();
  var message = null;
  if (board.winner === "X") {
    message = "You win!";
  } else if (board.winner === "O") {
    message = "You lose!";
  } else {
    message = "Draw!";
  }

  document.getElementById("notice").innerHTML=message;
});
