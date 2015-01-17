Array.prototype.uniq = function() {
  var seen = [];
  this.forEach(function(el) {
    if (seen.indexOf(el) === -1) {
      seen.push(el);
    }
  });
  return seen;
}

Array.prototype.transpose = function() {
  var transposed = [[null, null, null], [null, null, null], [null, null, null]];
  for (var row = 0; row < 3; row++) {
    for (var col = 0; col < 3; col++) {
      transposed[col][row] = this[row][col];
    }
  }
  return transposed;
}

function Board() {
  this.grid = [[null, null, null], [null, null, null], [null, null, null]];
  this.winner = null;
}

Board.prototype.won = function() {
  var that = this;

  var result = false;

  var diag1 = [];
  var diag2 = [];
  for (var i = 0; i < 3; i++) {
    diag1.push(this.grid[i][i]);
    diag2.push(this.grid[i][ Math.abs(2-i) ]);
  }

  var check = function(row) {
    if (row[0] && row.uniq().length === 1) {
      that.winner = row[0];
      result = true;
    }
  };

  // check rows
  this.grid.forEach(function(row) {
    check(row);
  });

  // checks cols
  this.grid.transpose().forEach(function(row) {
    check(row);
  });

  check(diag1);

  check(diag2);

  return result;
};

Board.prototype.winner = function() {
  return this.winner;
};

Board.prototype.empty = function(pos) {
  x = pos[0];
  y = pos[1];

  if (this.grid[y][x] === null ) {
      return true;
  }

  return false;
};

Board.prototype.placeMark = function(pos, mark) {
  x = pos[0];
  y = pos[1];

  if (this.empty(pos)) {
    this.grid[y][x] = mark;
    return true;
  }
  return false;
};

Board.prototype.print = function(){

  console.log("");

  this.grid.forEach(function(row){
    var str = "";
    row.forEach(function(el){
      if (el){
        str += el + " "
      } else {
        str += "_ "
      }
    });

    console.log(str);
  });
};


module.exports = Board;
