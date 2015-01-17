var readline = require('readline');
var reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

var askIfLessThan = function (el1, el2, callback) {

  reader.question("Is " + el1 + " less than " + el2 + "?", function(answer){
    if (answer === "yes") {
      callback(true);
    } else {
      callback(false);
    }
  });
};

var innerBubbleSortLoop = function (arr, i, madeAnySwaps, outerBubbleSortLoop) {
  if (i < arr.length - 1) {
    askIfLessThan(arr[i], arr[i + 1], function(isLessThan) {
      if (isLessThan === true) {
        innerBubbleSortLoop(arr, i+1, false, outerBubbleSortLoop);
      } else {
        arr[i + 1] = [arr[i], arr[i] = arr[i + 1]][0];
        innerBubbleSortLoop(arr, i+1, true, outerBubbleSortLoop);
      }
    });
  } else if (i == arr.length - 1) {
    outerBubbleSortLoop(madeAnySwaps);
  }
};

var absurdBubbleSort = function (arr, sortCompletionCallback) {
  function outerBubbleSortLoop (madeAnySwaps) {
    if (madeAnySwaps == true) {
      innerBubbleSortLoop(arr, 0, false, outerBubbleSortLoop)
    } else {
      sortCompletionCallback(arr);
      reader.close();
    }
  }
  outerBubbleSortLoop(true);
};

absurdBubbleSort([3, 2, 1], function (arr) {
  console.log("Sorted array: " + JSON.stringify(arr));
  reader.close();
});
