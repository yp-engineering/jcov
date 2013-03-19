// for acorn
var self = this;

JCov = (function () {

  var calculateCoverageData = function (code, file) {
    var tree = acorn.parse(code, {locations: true});

    acorn.walk.simple(tree, {
      Statement: function (node) {
        // cover all statements
        if (node.type !== "BlockStatement") {
          lineCovered(file, node.loc.start.line);
        }
      },
      ObjectExpression: function (node) {
        // ignore object keys
        var props = node.properties;
        for (var i = 0; i < props.length; i++) {
          ignoreLine(file, props[i].key.loc.start.line);
        }
      },
      IfStatement: function (node) {
        // ignore else statements
        if (node.alternate) {
          ignoreLine(file, node.alternate.loc.start.line);
        }
        // ignore non-block single if statements
        if (node.consequent.type !== "BlockStatement") {
          ignoreLine(file, node.consequent.loc.start.line);
        }
      },
      SwitchStatement: function (node) {
        // ignore switch cases
        var cases = node.cases;
        for (var i = 0; i < cases.length; i++) {
          ignoreLine(file, cases[i].loc.start.line);
        }
      },
      VariableDeclaration: function (node) {
        // multiline assignment madness
        if (node.loc.end.line > node.loc.start.line) {
          var declarations = node.declarations;
          for (var i = 1; i < declarations.length; i++) {
            // ignore the first line of each declaration
            ignoreLine(file, declarations[i].loc.start.line);
          }
        }
      }
    });
  };

  return {
    calculateCoverageData: calculateCoverageData
  };

})();
