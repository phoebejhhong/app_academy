function bubbleSort(ary) {
  var sorted = false;
  while(!sorted) {
    sorted = true
    for (var i = 0; i < ary.length -1; i++) {
        if(ary[i] > ary[i+1]) {
          var temp = ary[i+1];
          ary[i+1] = ary[i];
          ary[i] = temp;
          sorted = false;
        }
      }
    }
    return ary;
}

String.prototype.substrings = function() {
  var result = [];
  for (var i = 0; i < this.length; i++) {
    for (var j = i+1; j < this.length+1; j++) {
      var substring = this.slice(i, j);
      if (result.indexOf(substring) === -1){
        result.push(substring);
      }
    }
  }
  return result;
};
