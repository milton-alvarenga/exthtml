const fs = require("fs");
const peg = require("peggy");

const grammar_content = fs.readFileSync("./grammar/validation/validation.pegjs", "utf8");

const parser = peg.generate(grammar_content);

const directoryPath = "./source_code/validation/";
const directoryPathResults = "./expected_result/validation/";

fs.readdir(directoryPath, function(err, files) {
    if (err) {
        console.log("Error getting directory information.")
    } else {
        let fails = [];
        files.forEach(function(file) {
            var source_code_content = fs.readFileSync(directoryPath + `/${file}`, "utf8");
            var filename = file.split(".extval")[0];
            var parser_expected_result = fs.readFileSync(directoryPathResults + `/${filename}.json`, "utf8");
            var ast = parser.parse(source_code_content);

            try{ 
                var ast = parser.parse(source_code_content);
            } catch (e) {
                console.log(filename +':', '\x1b[31m','Parser Error','\x1b[0m');
                return;
            }

            var string_result = JSON.stringify(JSON.parse(parser_expected_result));
            var string_ast = JSON.stringify(ast);

            var result =  string_result == string_ast;

            if(result){
                console.log(filename +':', '\x1b[32m','Success','\x1b[0m');
            } else {
                console.log(filename +':', '\x1b[31m','Failed','\x1b[0m');
                fails.push([filename,string_result,string_ast]);
            }
        });
        fails.forEach(function(aFail,index){
            if(index === 0){
                console.log("#################################");
            }
            let filename = aFail[0];
            let string_result = aFail[1];
            let string_ast = aFail[2];

            console.log(filename);  
            console.log("Result:");
            console.log(string_result);
            console.log("==============");
            console.log("AST");
            console.log(string_ast);
            console.log("-------------------------------------------------");
        });
    }
});
