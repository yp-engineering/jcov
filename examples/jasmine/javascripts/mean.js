Math.mean = function (array) {
  if (array.length === 0) {
    return 0;
  }
  var sum = 0;
  for (var i = 0; i < array.length; i++) {
    sum += array[i];
  }

  return sum / array.length;
};
