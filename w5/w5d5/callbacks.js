function Clock() {
  this.time = null;
}

Clock.TICK = 5000;

Clock.prototype.printTime = function () {
  // Format the time in HH:MM:SS
  console.log(this.time.getHours() + ":" +
              this.time.getMinutes() + ":" +
              this.time.getSeconds())
};

Clock.prototype.run = function () {

  var clock = this;

  // 1. Set the currentTime.
  this.time = new Date;

  // 2. Call printTime.
  this.printTime();

  // 3. Schedule the tick interval.
  // setInterval(clock._tick.bind(clock), Clock.TICK);
  setInterval(function(){
    clock._tick();
  }, Clock.TICK);

};

Clock.prototype._tick = function () {
  // 1. Increment the currentTime.
  this.time = new Date(this.time.getTime() + Clock.TICK);

  // 2. Call printTime.
  this.printTime();
};

var clock = new Clock();
clock.run();
