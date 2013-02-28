JCov = (function () {

  var filename;

  var visitNodeList = function (nodes) {

    for (var i = 0; i < nodes.length; i++) {
      var node = nodes[i];

      visitNode(node);
    }

  };

  var visitNode = function (node) {
    if (node) { 

      if (node.loc) {
        lineCovered(filename, node.loc.start.line);
      }

      if (node.declarations) {
        visitDeclarations(node.declarations);
      } else if (node.expression) {
        if (node.expression.left) {
          visitNode(node.expression.left);
          visitNode(node.expression.right);
        } else if (node.expression.arguments) {
          visitArguments(node.expression.arguments);
        }
      } else if (node.body) {
        if (node.body.length) {
          visitNodeList(node.body);
        } else {
          visitNode(node.body);
        }
      } else if (node.consequent) {
        visitNode(node.consequent);
      }
    }
  };

  var visitDeclarations = function (declarations) {
    for (var i = 0; i < declarations.length; i++) {
      var decl = declarations[i];
      if (decl.init.body) {
        visitNodeList(decl.init.body.body);
      }
    }
  };

  var visitArguments = function (args) {
    for (var i = 0; i < args.length; i++) {
      var arg = args[i];
      if (arg.body) {
        visitNodeList(arg.body.body);
      }
    }
  };

  var calculateCoverageData = function (code, file) {
    filename = file;
    var tree = esprima.parse(code, {loc: true});

    visitNodeList(tree.body);
  };

  return {
    calculateCoverageData: calculateCoverageData
  };

})();
