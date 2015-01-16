
function Cat (name, owner) {
  this.name = name;
  this.owner = owner;
}

Cat.prototype.cuteStatement = function cuteStatement () {
  return this.owner + "loves" + this.name;
};

var gizmo = new Cat("gizmo", "ned");
var dog = new Cat("doggy", "ned");
// console.log(gizmo.cuteStatement());
// console.log(dog.cuteStatement());

Cat.prototype.cuteStatement = function () {
  return "Everyone loves " + this.name;
};
// console.log(gizmo.cuteStatement());
// console.log(dog.cuteStatement());


Cat.prototype.meow = function () {
  return "meow";
};

// console.log(gizmo.meow());
// console.log(dog.meow());
// dog.meow = function() {return "woof"}
// console.log(gizmo.meow());
// console.log(dog.meow());


function Student(firstName, lastName) {
  this.name = firstName + lastName;
  this.courses = [];
}

Student.prototype.enroll = function (course) {
  for(var i =0; i < this.courses.length; i++) {
    if(this.courses[i].conflictsWith(course)) {
      console.log("Conflict!")
      return
    }
  }
  this.courses.push(course);
  course.students.push(this);
}

Student.prototype.courseLoad = function () {
  load = {}
  this.courses.forEach(function(course) {
    if(load[course.dep]) {
      load[course.dep] += course.numCredits
    }
    else{
      load[course.dep] = course.numCredits
    }
  }
  )
  return load;
}

function Course(courseName, dep, numCredits, days, timeBlock) {
  this.courseName = courseName;
  this.dep = dep;
  this.numCredits = numCredits;
  this.students = [];
  this.days = days;
  this.timeBlock = timeBlock;
}

Course.prototype.addStudent = function (student) {
  student.enroll(this);
}

Course.prototype.conflictsWith = function (anotherCourse) {
  var conflict = false;
  var thisTimeBlock = this.timeBlock;
  this.days.forEach ( function (day) {
    anotherCourse.days.forEach ( function (anotherDay){
      if (day === anotherDay && thisTimeBlock == anotherCourse.timeBlock) {
        conflict = true;
      }
    })
  })
  return conflict;
}

s = new Student("J", "H");
c = new Course("Programming", "CS", 2, ["mon", "wed"], 1);
c2 = new Course("Programming2", "CS", 3, ["wed", "thu"], 1);

s.enroll(c);
c2.addStudent(s);
console.log(s.courseLoad());
console.log(s.courses);
console.log(c.students);
console.log(c.conflictsWith(c2))
