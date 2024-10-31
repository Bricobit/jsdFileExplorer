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

rem Ruta de las carpetas
set "source=app"
set "destination=out"

rem Elimina la carpeta de destino si ya existe y crea una nueva
if exist "%destination%" rd /s /q "%destination%"
mkdir "%destination%"

rem retrieve the path where the .bat file is located -> sample: C:\Users\BricoBit\Desktop\Nueva carpeta\
set thisFolder=%~dp0

rem Variable para el símbolo de exclamación
setlocal disabledelayedexpansion
set "exclam=!"
setlocal enabledelayedexpansion

rem Archivo para el índice
set "indexFile=index.html"
echo ^<!exclam!DOCTYPE html^> > "%indexFile%"
echo ^<html^> >> "%indexFile%"
echo ^<head^> >> "%indexFile%"
echo     ^<title^>Índice de Archivos HTML^</title^> >> "%indexFile%"
echo     ^<style^> >> "%indexFile%"
echo         html { width: 100%%; height: 100%%; border: none; } >> "%indexFile%"
echo         body {width: 100%%; height: 100%%; display: flex; margin: 0; font-family: Arial, sans-serif; } >> "%indexFile%"
echo         nav {overflow-x: auto;overflow-y: auto; width: 200px; background-color: #f4f4f4; padding: 20px; box-shadow: 2px 0 5px rgba(0,0,0,0.1); position: fixed; height: 100%; overflow-y: auto; } >> "%indexFile%"
echo         main { width: 100%%; height: 100%%; margin-left: 220px; padding: 20px; flex-grow: 1; } >> "%indexFile%"
echo         a { text-decoration: none; color: #333; display: block; margin-bottom: 10px; } >> "%indexFile%"
echo         a:hover { color: #007BFF; } >> "%indexFile%"
echo         iframe { width: 100%%; height: 100%%; border: none; } >> "%indexFile%"
echo     ^</style^> >> "%indexFile%"
echo ^</head^> >> "%indexFile%"
echo ^<body^> >> "%indexFile%"
echo ^<nav^> >> "%indexFile%"
echo     ^<h1^>Índice de Archivos HTML^</h1^> >> "%indexFile%"
echo     ^<ul^> >> "%indexFile%"

rem Recorre todos los archivos .js dentro de la carpeta source
for /r %source% %%f in (*.js) do (
    rem C:\Users\BricoBit\Desktop\Nueva carpeta\app\core\Book.js 
    set "filepath=%%f"
    rem Book sin extension
    set "filename=%%~nf"
    rem C:\Users\BricoBit\Desktop\Nueva carpeta\app\core\Book
    set "relpath=%%~dpnf"
    rem core\Book
    set "relpath=!relpath:%thisFolder%%source%\=!"
    rem out\core\Book.html
    set "htmlpath=%destination%\!relpath!.html"
    rem Crea el directorio correspondiente en out si no existe y evita crear un directorio cuando es un archivo
    if not exist "%destination%\!relpath!\.." mkdir "%destination%\!relpath!\.."
    rem esta opcion creaba tambien una carpeta con el mismo nombre que el archivo
    rem if not exist "%destination%\!relpath!" mkdir "%destination%\!relpath!"
    rem Copia el contenido del .js en un archivo .html dentro del body
    echo ^<!exclam!DOCTYPE html^> > "!htmlpath!"
    echo ^<html^> >> "!htmlpath!"
    echo ^<head^> >> "!htmlpath!"
    echo ^<title^>!filename!^</title^> >> "!htmlpath!"
    echo ^</head^> >> "!htmlpath!"
    echo ^<body^> >> "!htmlpath!"
    echo ^<pre^> >> "!htmlpath!"
    type "!filepath!" >> "!htmlpath!"
    echo ^</pre^> >> "!htmlpath!"
    echo ^</body^> >> "!htmlpath!"
    echo ^</html^> >> "!htmlpath!"
    rem Agrega un enlace al archivo en el índice
    set "relativePath=!relpath!.html"
    rem invertimos las barras para las url html
    set "relativePath=!relativePath:\=/!"
    echo ^<li^>^<a href="!destination!\!relativePath!" target="contentFrame"^>!filename!^</a^>^</li^> >> "%indexFile%"
)

rem Cierra las etiquetas del archivo índice
echo     ^</ul^> >> "%indexFile%"
echo ^</nav^> >> "%indexFile%"
echo ^<main^> >> "%indexFile%"
echo     ^<iframe name="contentFrame"^>^</iframe^> >> "%indexFile%"
echo ^</main^> >> "%indexFile%"
echo ^</body^> >> "%indexFile%"
echo ^</html^> >> "%indexFile%"
echo Archivo índice y conversiones completadas.
pause

