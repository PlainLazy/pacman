@chcp 1251

@echo --

cd src

@SET compiler=%mxmlc46%
@%compiler% -version
@rem -link-report="rep.xml" ^
@%compiler% ^
-tools-locale=en -accessible=true -use-network=false -keep-generated-actionscript=false ^
-incremental=false -debug=false -verbose-stacktraces=false -optimize=true -benchmark=true ^
-creator="PlainLazy" ^
-default-size 480 360 -default-frame-rate 24 -default-background-color=0x000000 ^
-target-player=14 -swf-version=25 ^
-define=CONFIG::debug,false ^
-static-link-runtime-shared-libraries=true ^
-source-path="../../Alternativa3D-master/src/,../../Alternativa3DUtils-master" ^
-output="../www/pacman.swf" ^
"Pacman.as"

@pause
:end