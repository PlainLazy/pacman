# pacman

зависимость https://github.com/AlternativaPlatform/Alternativa3D

* pacman.as3proj - файл проект FlashDevelop
* build.bat - сборка через mxmlc
* src/Pacman.as - главный класс
* www/index.html - морда
* www/pacman.swf - компилируемый файл
* www/pacman.cnf - конфигурационный файл

* конфигурация:

  player<br>
  &nbsp; .mark - метка игрока на карте<br>
  &nbsp; .speed - вес скорости игрока<br>
  monsters<br>
  &nbsp; .mark - метка монстра на карте<br>
  &nbsp; .speed - вес скорости монстра<br>
  &nbsp; .type - тип поведения монстра<br>
  &nbsp;&nbsp;   // stupid - тупо будет метаться<br>
  &nbsp;&nbsp;   // linear - будет ходить по прямой иногда поворачивая<br>
  &nbsp;&nbsp;   // assassin - будет стремиться к позиции игрока<br>
  map:<br>
  &nbsp; // шаблон уровня в виде списка из строк<br>
  &nbsp; // уровень состоит из ячеек с координатами X и Y<br>
  &nbsp; // координата Y ячейки - порядковый номер соответствующей строки<br>
  &nbsp; // координата X ячейки - порядковый номер символа в соответствующей строки<br>
 
