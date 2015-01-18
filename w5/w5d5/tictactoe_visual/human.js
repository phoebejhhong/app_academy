
function Human(board) {
  this.board = board;
  this.mark = "X";
}

Human.prototype.getMove = function(callback){
  var that = this;
  this.board.print();

  var squares = document.getElementsByClassName("square");

  var getClick = function() {

    var x = parseInt(this.id.slice(0,1));
    var y = parseInt(this.id.slice(1,2));

    for(var i = 0 ; i < squares.length; i++){
      squares[i].removeEventListener('click', getClick);
    }

    callback([x,y]);
  };

  for(var i = 0 ; i < squares.length; i++){
    squares[i].addEventListener('click', getClick);
  }
};
