
Array.prototype.myEach = function (eachMethod){
  for (var i =0; i < this.length; i++) {
    eachMethod(this[i]);
  }
};


Array.prototype.myMap =  function(eachMethod) {
  var result =[];
  this.myEach(function (el) {
    result.push(eachMethod(el));
  });

  return result;
};

Array.prototype.myInject = function(eachMethod) {
  var result = this[0];
  function myInjectMethod(el) {
    result = eachMethod(result, el);
  };
  this.slice(1,this.length).myEach(myInjectMethod);
  return result;
};
