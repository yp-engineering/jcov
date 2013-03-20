// for acorn
var self = this;

JCov = (function () {

  var calculateCoverageData = function (code, file) {
    var tree = acorn.parse(code, {locations: true});

    acorn.walk.simple(tree, {
      Statement: function (node) {
        // cover all statements
        if (node.type !== "BlockStatement" &&
            node.type !== "EmptyStatement") {
          var pos = node.loc.start;
          lineCovered(file, pos.line, pos.column);
        }
      },
      IfStatement: function (node) {
        // ignore else statements
        if (node.alternate) {
          ignoreLine(file, node.alternate.loc.start.line);
        }

        if (node.consequent.type !== "BlockStatement") {
          var ifStart   = node.loc.start.line;
          var thenStart = node.consequent.loc.start.line;
          if (ifStart < thenStart) {
            // ignore non-block single if statements if they're on
            // their own line
            ignoreLine(file, node.consequent.loc.start.line);
          } else if (ifStart === thenStart) {
            // single line if statement, mark the whole line
            lineCovered(file, ifStart, 0);
          }
        }
      }
    });
  };

  return {
    calculateCoverageData: calculateCoverageData
  };

})();
