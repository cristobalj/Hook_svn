set REPOS=%1
set TXN=%2
set primero=123
set var_concatenar_sin_coma=0
set archivos_separados_x_coma=
Set /a pos=0
set entre_if_una_vez=0
set eliminar_primera_letra=
set contador_uno=0
set mensaje_customizado=Requerimiento
set mensaje_archivos_sin_id_alm=Archivos sin id en alm:
set comparativo_mensaje_archivos_sin_id_alm=Archivos sin id en alm:

setlocal EnableDelayedExpansion
set message= 
For /F "delims=" %%I in ('svnlook log %1 -t %2') Do Set message=%%I

if "%message:~0,5%%" EQU "Admin" (
exit 0
)

set archivos=
For /F "delims=" %%I in ('svnlook changed  %1 -t %2') Do (
set /A contador_uno+=1
set  variable2=%%I

set  variable1="!variable2: =!"


for /F "tokens=1-4 delims=/" %%a in (!variable1!) do (

  set archivo_sin_path=%%d
  
)
set vector[!contador_uno!]=!archivo_sin_path!
)

for /L %%k in (1,1,%contador_uno%) do ( 
	call set "archivos_separados_x_coma=%%archivos_separados_x_coma%% ,!vector[%%k]!"
	set archivo_no_existe=0
	for /f "usebackq tokens=1-4 delims=," %%a in ("C:\FTP\example.csv") do (
		if %%a equ !vector[%%k]! (

			call set "mensaje_customizado=%%mensaje_customizado%% #%%b,"	
			set /A archivo_no_existe+=1
		) 
	)
	if "!archivo_no_existe!" equ "0" (
		call set "mensaje_archivos_sin_id_alm=%%mensaje_archivos_sin_id_alm%% !vector[%%k]!"
		)
)
set mensaje_customizado=%mensaje_customizado:~0,-1%:msg_test
set archivos_separados_x_coma=%archivos_separados_x_coma:1%

if !mensaje_archivos_sin_id_alm! NEQ !comparativo_mensaje_archivos_sin_id_alm! (
echo Su commit a sido bloqueado razon: >&2
echo %mensaje_archivos_sin_id_alm% >&2 
exit 1
)
if "%mensaje_customizado%" NEQ "%message%" (
echo Su mensaje debera ser de la siguiente manera, preocupese de que no hayan espacios al final >&2 
echo %mensaje_customizado% >&2
exit 1
)
if "%mensaje_customizado%" EQU "%message%" (
exit 0
)


