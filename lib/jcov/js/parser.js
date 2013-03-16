// for acorn
var self = this;

JCov = (function () {

  var calculateCoverageData = function (code, file) {
    var tree = acorn.parse(code, {locations: true});

    acorn.walk.simple(tree, {
      Statement: function (node) {
        // print(node.loc.start.line + " :: " +node.type);
        lineCovered(file, node.loc.start.line);
      },
      ObjectExpression: function (node) {
        // ignore object keys
        var props = node.properties;
        for (var i = 0; i < props.length; i++) {
          // print("ignore " + props[i].key.loc.start.line);
          ignoreLine(file, props[i].key.loc.start.line);
        }
      },
      IfStatement: function (node) {
        if (node.alternate) {
          ignoreLine(file, node.alternate.loc.start.line);
        }
      }
    });
  };

  return {
    calculateCoverageData: calculateCoverageData
  };

})();
