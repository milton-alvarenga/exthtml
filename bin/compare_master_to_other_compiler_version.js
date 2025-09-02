import { fileURLToPath } from 'url';
import fs from 'fs';
import path from 'path';
import { exec } from 'child_process';


const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

//Expected the git hash of the commits to be used
const args = process.argv.slice(2);
const gitHash = args.length > 0 ? args[0] : 'master';

runGitCommands();

const root_destination = "/tmp/exthtml";

if (!fs.existsSync(root_destination)) {
  fs.mkdirSync(root_destination);
  console.log(`${root_destination} directory created.`);
}

function runCommand(cmd) {
  return new Promise((resolve, reject) => {
    exec(cmd, (err, stdout, stderr) => {
      if (err) {
        reject(stderr || err);
      } else {
        resolve(stdout);
      }
    });
  });
}

function getAllExtHTMLFiles(dirPath, arrayOfFiles) {
  const files = fs.readdirSync(dirPath);

  arrayOfFiles = arrayOfFiles || [];

  files.forEach(function(file) {
    const fullPath = path.join(dirPath, file);
    if (fs.statSync(fullPath).isDirectory()) {
      arrayOfFiles = getAllExtHTMLFiles(fullPath, arrayOfFiles);
    } else if (path.extname(file) === '.exthtml') {
      arrayOfFiles.push(fullPath);
    }
  });

  return arrayOfFiles;
}

async function runGitCommands() {
  try {
    console.log('Checking out master...');
    await runCommand('git checkout master');
    console.log('Pulling latest changes...');
    await runCommand('git pull');
    
    if (gitHash !== 'master') {
      console.log(`Checking out ${gitHash}...`);
      await runCommand(`git checkout ${gitHash}`);
    }

    console.log('Git operations completed successfully.');
  } catch (error) {
    console.error('Error during git commands:', error);
  }
}

const baseDir = path.join(__dirname, '..', 'src', 'examples', 'exthtml');
const exthtmlFiles = getAllExtHTMLFiles(baseDir);

console.log('All .exthtml files found:', exthtmlFiles);


const targetDir = path.join(root_destination, gitHash);
if (!fs.existsSync(targetDir)) {
  fs.mkdirSync(targetDir, { recursive: true });
}

exthtmlFiles.forEach(arg => {
  exec(`node ${__dirname}/../execute_compiler.js ${arg}`, (error, stdout, stderr) => {
    if (error) {
      console.error(`Error executing script with argument ${arg}:`, error);
      return;
    }
    if (stderr) {
      console.error(`stderr for argument ${arg}:`, stderr);
      return;
    }

    let filename = path.basename(arg)
    const sourcePath = path.join('.', path.basename(arg, path.extname(arg))+".js");

    // Define target file path
    const targetPath = path.join(targetDir, filename);

    // Move and rename the file
    fs.copyFile(sourcePath, targetPath, (err) => {
        if (err) {
            console.error('Error copying file:', err);
        } else {
            console.log(`File copied from ${sourcePath} to ${targetPath}`);
        }
    });


    console.log(`stdout for argument ${arg}:`, stdout);
  });
});