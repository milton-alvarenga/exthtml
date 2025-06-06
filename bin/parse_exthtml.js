const fs = require("fs");
const peg = require("peggy");
const jsonDiff = require('json-diff');



const grammar_content = fs.readFileSync("./src/parse/peg/grammar/exthtml/current.pegjs", "utf8");

const parser = peg.generate(grammar_content);

const directoryPath = "./src/parse/peg/source_code/exthtml/";
const directoryPathResults = "./src/parse/peg/expected_result/exthtml/";

let final_status = {
    total_files:0,
    total_sucess:0,
    total_fail:0,
    total_not_tested:0,
}
fs.readdir(directoryPath, function(err, files) {
    if (err) {
        console.log("Error getting directory information.")
    } else {
        let fails = [];
        files.forEach(function(file) {
            final_status.total_files++
            var source_code_content = fs.readFileSync(directoryPath + `/${file}`, "utf8");
            var filename = file.split(".exthtml")[0];
            try {
                var parser_expected_result = fs.readFileSync(directoryPathResults + `/${filename}.json`, "utf8");
            } catch(err){
                final_status.total_not_tested++;
                if (err.code === 'ENOENT') {
                    // Handle file not found error
                    console.log(filename +':', '\x1b[33m','JSON result File not found','\x1b[0m');
                    return;
                } else {
                    // Handle other possible errors
                    console.error(`An error occurred while reading the file: ${err.message}`);
                    return;
                }
            }

            if (!parser_expected_result || parser_expected_result.length === 0){
                final_status.total_not_tested++;
                console.log(filename +':', '\x1b[33m','JSON result File is empty','\x1b[0m');
                return
            }

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
                final_status.total_sucess++;
                console.log(filename +':', '\x1b[32m','Success','\x1b[0m');
            } else {
                final_status.total_fail++;
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
            console.log("++++++++++++++");
            console.log("Diff");
            console.log(jsonDiff.diffString(JSON.parse(string_ast),JSON.parse(string_result)));
            console.log("-------------------------------------------------");
        });
        console.log("Final status:");
        console.log(`\tTotal files: ${final_status.total_files}`);
        console.log(`\tTotal success: ${final_status.total_sucess}`);
        console.log(`\tTotal fails: ${final_status.total_fail}`);
        console.log(`\tTotal files not tested: ${final_status.total_not_tested}`);
    }
});
