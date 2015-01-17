var Game = function(reader, board, computer, human){
  this.reader = reader;
  this.board = board;
  this.computer = computer;
  this.human = human;
  this.turn = human;
};

Game.prototype.run = function(completionCallback) {
  var that = this;
  var handleInput = function(pos) {
    var success = that.board.placeMark(pos, that.turn.mark);
    if (!success) {
      console.log("error!");
    } else {
      if ( that.board.won() ) {
        completionCallback();
      } else {
        that.turn = (that.turn === that.human ? that.computer : that.human);
        that.run(completionCallback);
      }
    }
  }
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


module.exports = Game;
