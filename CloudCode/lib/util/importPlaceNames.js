
console.log("Hello World");

var SSRImporter = require("./SSRImporter.js").SSRImporter;
var importer = new SSRImporter();
var fileName = process.argv[2];
importer.importFromFile(fileName, {
	success: function(message) {
		console.log("succeeded with message: " + message);
	}
})