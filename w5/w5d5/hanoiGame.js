var readline = require('readline');
var reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});


function HanoiGame () {
  this.stacks = [[3,2,1],[],[]];
};

HanoiGame.prototype.isWon = function(){
  if (this.stacks[2].length === 3 ){
    return true;
  } else {
    return false;
  }
};

HanoiGame.prototype.isValidMove = function(startTowerIdx, endTowerIdx) {
  var startTower = this.stacks[startTowerIdx];
  var startDisc = startTower[startTower.length - 1];

  var endTower = this.stacks[endTowerIdx];
  var endDisc = endTower[endTower.length - 1];

  if (!startDisc) {
    return false;
  } else if (!endDisc || startDisc < endDisc) {
    return true;
  } else {
    return false;
  }
};

HanoiGame.prototype.move = function(startTowerIdx, endTowerIdx) {
  if (this.isValidMove(startTowerIdx, endTowerIdx)){
    var startTower = this.stacks[startTowerIdx];
    var endTower = this.stacks[endTowerIdx];
    endTower.push(startTower.pop());
    return true;
  }

  return false;
};

HanoiGame.prototype.print = function(){
  console.log(JSON.stringify(this.stacks));
};

HanoiGame.prototype.promptMove = function(callback){

  this.print();

  var result = true;

  reader.question("Where from? [0,1,2]", function(from){
    reader.question("Where to? [0,1,2]", function(to){
      result = callback(from, to);
    });
  });

  return result;
};

HanoiGame.prototype.run = function(completionCallback) {

  var that = this;

  this.promptMove(function(s, e) {
    var success = that.move(s, e);
    if (!success) {
      console.log("error!");
    } else {
      if ( that.isWon() ) {
        completionCallback();
      } else {
        that.run(completionCallback);
      }
    }
  });
}



game = new HanoiGame();
game.run(function(){
  console.log("Good Job");
  reader.close();
});
