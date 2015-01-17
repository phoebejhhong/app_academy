Function.prototype.myBind = function(context) {
  var fn = this;
  return function() {
    fn.apply(context);
  };
};

function Cat(name) {
  this.name = name;
};
var meow = function () {
  console.log("meouwedfr");
}
cat = new Cat("gizmo");

setTimeout(meow.myBind(cat), 1000);
