
function range(start_num, end_num) {
  if (start_num >= end_num) {
    return [];
  }
  else {
    var temp = [start_num];
    return temp.concat(range(start_num+1, end_num));
  }
};

function recSum(ary){
  if (ary.length === 1) {
    return ary[0];
  }
  else{
    return ary[0] + recSum(ary.slice(1,ary.length));
  }
};

function expo(num, exp) {
  if (exp ===0) {
    return 1;
  } else if (exp === 1) {
    return num;
  } else if (exp % 2 === 0) {
    return Math.pow(expo(num, exp/2), 2);
  } else {
    return num * (Math.pow(expo(num, (exp-1)/2), 2));
  }
};

function fibonacci(num) {
  if (num === 1){
    return [0];
  } else if (num === 2){
    return [0, 1];
  } else {
    prevArray = fibonacci(num-1);
    prevArray.push(prevArray[prevArray.length-1] + prevArray[prevArray.length-2]);
    return prevArray;
  };
};


function binarySearch(array, target) {
  var mid = Math.floor(array.length / 2);
  var left = array.slice(0,mid);
  var right = array.slice(mid, array.length);

  if (target === array[mid]){
    return mid;
  } else if(target > array[mid]) {
    return mid + binarySearch(right, target);
  } else {
    return binarySearch(left, target);
  }
}

function makeChange(num, array) {

};

function mergeSort(array) {
  if (array.length < 2) {
    return array;
  } else {
    var mid = Math.floor(array.length / 2);
    var left = array.slice(0,mid);
    var right = array.slice(mid, array.length);
    return merge(mergeSort(left), mergeSort(right));
  }
};

function merge(left, right) {
  var merged = [];
  while (left.length > 0 && right.length > 0) {
    if (left[0] > right[0]) {
      merged.push(right.shift());
    } else {
      merged.push(left.shift());
    }
  }
  return merged.concat(left).concat(right);
}


function subsets(arr) {
  if (arr.length === 0) {
    return [[]];
  } else {
    var currentVal = arr[arr.length - 1];
    var oldArr = subsets(arr.slice(0, arr.length - 1));
    var newArr = [];

    oldArr.forEach(function(el) {
      el.push(currentVal)
      newArr.push(el)
    });
    return subsets(arr.slice(0, arr.length - 1)).concat(newArr);
  }
}

function makeChange(value, coins) {
  if (coins.length === 0) {
    return new Array(value+1);
  } else {
    var change = [];
    var remainingChange = value;
    for (var i = 0; i< coins.length; i++) {
      if(remainingChange/ coins[i]>1) {
        var numberOfCoins = Math.floor(remainingChange / coins[i]);
        remainingChange -= (numberOfCoins * coins[i]);
        while (numberOfCoins--) {
          change.push(coins[i]);
        }
      }
    }
    next_change = makeChange(value, coins.slice(1, coins.length));
    if (change.length > next_change.length) {
      change = next_change
    }
    return change;
  }
}
