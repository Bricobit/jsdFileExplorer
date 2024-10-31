/*
jsdFileExplorer
Author: Javier Vicente Medina - giskard2010@hotmail.com 
bricobit.com - jaction.org

@license
This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL
was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.
Unless required by applicable law or agreed to in writing, software distributed under the License is
distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
*/
const fs = require('fs');
const path = require('path');
const Prism = require('prismjs');
require('prismjs/components/prism-javascript');

const sourceDir = 'app';
const destinationDir = 'jsdoc';

function createIndexFile() {
    const indexFilePath = 'index.html';
    const indexContent = `
<!DOCTYPE html>
<html>
<head>
    <title>Índice de Archivos HTML</title>
    <style>
        body {font-family: Arial, sans-serif; margin: 0; display: flex; height: 100vh;}
        nav {width: 250px; background-color: #333; padding: 10px; color: white; overflow-y: auto;}
        main {flex-grow: 1; padding: 20px;}
        a {color: #ddd; text-decoration: none;}
        .dropdown-btn {cursor: pointer; padding: 8px; width: 100%; text-align: left; border: none; background: none; color: #ddd; font-size: 16px;}
        .dropdown-container {display: none; padding-left: 15px;}
        a:hover, .dropdown-btn:hover {color: #fff;}
        .folder {color: #ffcc00;}
        .file {color: #00ccff;}
        .indent {margin-left: 20px;}
        .line {border-left: 1px solid #ddd; padding-left: 10px; margin-left: 10px;}
    </style>
</head>
<body>
    <nav>
        <h2>📂 Índice de Archivos HTML</h2>
        <ul id="fileList"></ul>
    </nav>
    <main>
        <iframe name="contentFrame" style="width:100%; height:100%; border:none;"></iframe>
    </main>
    <script>
        function toggleDropdown(element) {
            var container = element.nextElementSibling;
            container.style.display = container.style.display === "block" ? "none" : "block";
            element.textContent = container.style.display === "block" ? "📂 " + element.dataset.folderName + " ▼" : "📁 " + element.dataset.folderName + " ▶";
        }
    </script>
</body>
</html>
    `;
    fs.writeFileSync(indexFilePath, indexContent, 'utf8');
}

function processFile(filePath) {
    const fileName = path.basename(filePath, '.js');
    const relativePath = path.relative(sourceDir, filePath);
    const htmlPath = path.join(destinationDir, relativePath + '.html');
    const htmlDir = path.dirname(htmlPath);

    if (!fs.existsSync(htmlDir)) {
        fs.mkdirSync(htmlDir, { recursive: true });
    }

    const fileContent = fs.readFileSync(filePath, 'utf8');
    const highlightedContent = Prism.highlight(fileContent, Prism.languages.javascript, 'javascript');

    // Calcula la profundidad para la ruta relativa de prism.css
    const depth = relativePath.split(path.sep).length;
    const relativeCssPath = '../'.repeat(depth) + 'prism.min.css';

    const htmlContent = `
<!DOCTYPE html>
<html>
<head>
    <title>${fileName}</title>
    <link href="${relativeCssPath}" rel="stylesheet" />
</head>
<body>
    <pre><code class="language-javascript">${highlightedContent}</code></pre>
</body>
</html>
    `;

    fs.writeFileSync(htmlPath, htmlContent, 'utf8');
}

function processDirectory(dir, indentLevel = 0) {
    const files = fs.readdirSync(dir);

    files.forEach(file => {
        const filePath = path.join(dir, file);
        const stat = fs.statSync(filePath);

        if (stat.isDirectory()) {
            processDirectory(filePath, indentLevel + 1);
        } else if (path.extname(file) === '.js') {
            processFile(filePath);
        }
    });
}

function generateIndex() {
    const indexFilePath = 'index.html';
    let indexContent = fs.readFileSync(indexFilePath, 'utf8');
    let fileListContent = '';

    function addFilesToIndex(dir, parentFolder = '', indentLevel = 0) {
        const files = fs.readdirSync(dir);

        files.forEach(file => {
            const filePath = path.join(dir, file);
            const stat = fs.statSync(filePath);

            if (stat.isDirectory()) {
                const folderName = path.basename(filePath);
                fileListContent += `<button class="dropdown-btn folder indent line" style="margin-left: ${indentLevel * 20}px;" onclick="toggleDropdown(this)" data-folder-name="${folderName}">📁 ${folderName} ▶</button><ul class="dropdown-container">`;
                addFilesToIndex(filePath, folderName, indentLevel + 1);
                fileListContent += '</ul>';
            } else if (path.extname(file) === '.html') {
                const relativePath = path.relative(destinationDir, filePath).replace(/\\/g, '/');
                const fileName = path.basename(file, '.html');
                fileListContent += `<li class="file indent" style="margin-left: ${indentLevel * 20}px;"><a href="${destinationDir}/${relativePath}" target="contentFrame">📄 ${fileName}</a></li>`;
            }
        });
    }

    addFilesToIndex(destinationDir);
    indexContent = indexContent.replace('<ul id="fileList"></ul>', `<ul id="fileList">${fileListContent}</ul>`);
    fs.writeFileSync(indexFilePath, indexContent, 'utf8');
}

function main() {
    if (fs.existsSync(destinationDir)) {
        fs.rmSync(destinationDir, { recursive: true, force: true });
    }
    fs.mkdirSync(destinationDir);

    createIndexFile();
    processDirectory(sourceDir);
    generateIndex();

    console.log('Archivo índice y conversiones completadas.');
}

main();
