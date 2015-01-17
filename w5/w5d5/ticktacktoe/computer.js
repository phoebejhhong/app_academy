function Computer(board) {
  this.mark = "O";
  this.board = board;
};

Computer.prototype.getMove = function(callback){

  var pos = [];

  pos = this.getRandomPos();

  this.board.print();
  callback(pos);
};

Computer.prototype.getRandomPos = function(){
  var x = this.pickRandom();
  var y = this.pickRandom();

  while ( !this.board.empty([x,y]) ) {
    x = this.pickRandom();
    y = this.pickRandom();
  }

  return [x,y];
};

Computer.prototype.pickRandom = function(){
  return Math.floor(Math.random() * 3);
}

module.exports = Computer;
