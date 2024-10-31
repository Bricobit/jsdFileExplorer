@echo off
goto comment

jsdFileExplorer
Author: Javier Vicente Medina - giskard2010@hotmail.com 
bricobit.com - jaction.org

@license
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, You can obtain one at https://mozilla.org/MPL/2.0/.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
:comment
setlocal enabledelayedexpansion

rem Rutas de carpetas
set "source=app"
set "destination=jsdoc"

rem Elimina y crea la carpeta de destino
if exist "%destination%" rd /s /q "%destination%"
mkdir "%destination%"

rem Ejecuta el script de Node.js
node processFiles.js

rem Archivo índice
set "indexFile=index.html"
echo ^<!DOCTYPE html^> > "%indexFile%"
echo ^<html^> >> "%indexFile%"
echo ^<head^> >> "%indexFile%"
echo     ^<title^>Índice de Archivos HTML^</title^> >> "%indexFile%"
echo     ^<style^> >> "%indexFile%"
echo         body {font-family: Arial, sans-serif; margin: 0; display: flex; height: 100vh;} >> "%indexFile%"
echo         nav {width: 250px; background-color: #333; padding: 10px; color: white; overflow-y: auto; } >> "%indexFile%"
echo         main {flex-grow: 1; padding: 20px;} >> "%indexFile%"
echo         a {color: #ddd; text-decoration: none;} >> "%indexFile%"
echo         .dropdown-btn {cursor: pointer; padding: 8px; width: 100%%; text-align: left; border: none; background: none; color: #ddd; font-size: 16px;} >> "%indexFile%"
echo         .dropdown-container {display: none; padding-left: 15px;} >> "%indexFile%"
echo         a:hover, .dropdown-btn:hover {color: #fff;} >> "%indexFile%"
echo     ^</style^> >> "%indexFile%"
echo ^</head^> >> "%indexFile%"
echo ^<body^> >> "%indexFile%"
echo ^<nav^> >> "%indexFile%"
echo     ^<h2^>Índice de Archivos HTML^</h2^> >> "%indexFile%"
echo     ^<ul^> >> "%indexFile%"

rem Recorre los archivos HTML generados y genera la estructura del índice
for /r %destination% %%f in (*.html) do (
    set "filepath=%%f"
    set "filename=%%~nf"
    set "relpath=%%~dpnf"
    set "relpath=!relpath:%thisFolder%%destination%\=!"
    
    rem Detecta carpetas para crear dropdowns
    for %%d in (!relpath!) do set "folder=%%~pd"
    set "folder=!folder:~0,-1!"
    
    if "!lastFolder!" neq "!folder!" (
        if defined lastFolder (echo     ^</ul^> >> "%indexFile%")
        
        rem Extrae solo el último nombre de la carpeta de la ruta relativa a source usando el prefijo del path de origen
        for %%a in (!folder!) do set "folderName= %%~nxa"
        echo ^<button class="dropdown-btn" onclick="toggleDropdown(this)"^>!folderName!^</button^> >> "%indexFile%"
        echo     ^<ul class="dropdown-container"^> >> "%indexFile%"
        set "lastFolder=!folder!"
    )
    echo         ^<li^>^<a href="!destination!/!relpath!" target="contentFrame"^> !filename!^</a^>^</li^> >> "%indexFile%"
)

rem Cierra las etiquetas de HTML
echo     ^</ul^> >> "%indexFile%"
echo ^</nav^> >> "%indexFile%"
echo ^<main^> >> "%indexFile%"
echo     ^<iframe name="contentFrame" style="width:100%%; height:100%%; border:none;"^>^</iframe^> >> "%indexFile%"
echo ^</main^> >> "%indexFile%"
echo ^<script^> >> "%indexFile%"
echo     function toggleDropdown(element) { >> "%indexFile%"
echo         var container = element.nextElementSibling; >> "%indexFile%"
echo         container.style.display = container.style.display === "block" ? "none" : "block"; >> "%indexFile%"
echo     } >> "%indexFile%"
echo ^</script^> >> "%indexFile%"
echo ^</body^> >> "%indexFile%"
echo ^</html^> >> "%indexFile%"

echo Archivo índice y conversiones completadas.
pause

