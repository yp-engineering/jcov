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
          lineCovered(file, node.loc.start.line);
        }
      },
      ObjectExpression: function (node) {
        // ignore object keys
        var objectLine = node.loc.start.line;
        var props = node.properties;
        for (var i = 0; i < props.length; i++) {
          var line = props[i].key.loc.start.line;
          // only ignore object keys that are on subsequent lines from
          // the start of the definition
          if (objectLine < line) {
            ignoreLine(file, line);
          }
        }
      },
      IfStatement: function (node) {
        // ignore else statements
        if (node.alternate) {
          ignoreLine(file, node.alternate.loc.start.line);
        }
        // ignore non-block single if statements if they're on
        // their own line
        if (node.consequent.type !== "BlockStatement" &&
            node.loc.start.line < node.consequent.loc.start.line) {
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
        var startLine = node.loc.start.line;
        var declarations = node.declarations;
        for (var i = 1; i < declarations.length; i++) {
          var line = declarations[i].loc.start.line;
          // ignore the first line of each declaration
          // if it starts on subsequent lines
          if (line > startLine) {
            ignoreLine(file, line);
          }
        }
      }
    });
  };

  return {
    calculateCoverageData: calculateCoverageData
  };

})();
