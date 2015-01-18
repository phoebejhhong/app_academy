
function Human(reader, board) {
  this.reader = reader;
  this.board = board;
  this.mark = "X";
}

Human.prototype.getMove = function(callback){
  var that = this;
  this.board.print();

  this.reader.question("X? ", function(x){
    that.reader.question("Y? ", function(y){
      callback([x, y]);
    });
  });
};

module.exports = Human;
