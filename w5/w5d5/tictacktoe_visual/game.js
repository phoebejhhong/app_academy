var Game = function(board, computer, human){
  this.board = board;
  this.computer = computer;
  this.human = human;
  this.turn = human;
};

Game.prototype.run = function(completionCallback) {
  var that = this;
  var handleInput = function(pos) {
    that.board.placeMark(pos, that.turn.mark);
      if ( that.board.won() ) {
        completionCallback();
      } else {
        that.turn = (that.turn === that.human ? that.computer : that.human);
        that.run(completionCallback);
      }
    };

  if (this.turn === this.human) {
    this.human.getMove(function(pos){
      handleInput(pos)
    });
  } else{
    this.computer.getMove(function(pos){
        handleInput(pos)
    });
  }
};
