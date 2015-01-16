
Array.prototype.myUniq = function () {
  var unique_array = [];
  this.forEach( function (el) {
    if (unique_array.indexOf(el) === -1 ) {
      unique_array.push(el);
    }
  });
  return unique_array
};

Array.prototype.twoSum = function () {
  result = [];
  for (var i = 0; i < this.length - 1; i++) {
    for ( var j = i + 1; j < this.length; j++) {
      if (this[i] + this[j] === 0) {
        result.push([i, j]);
      }
    }
  }
  return result
};

Array.prototype.myTranspose = function () {
  result = [];
  for (var i = 0; i < this.length; i++) {
    temp_array = [];
    for (var j = 0; j <  this.length; j++) {
      temp_array.push(this[j][i]);
    }
    result.push(temp_array);
  }
  return result;
};
