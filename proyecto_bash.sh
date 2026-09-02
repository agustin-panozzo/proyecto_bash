#!/bin/bash

export FILENAME="alumnos"

if [ "$1" = "-d" ]; then

	if [ -f ~/EPNro1/consolidar.pid ]; then
		PID=$(cat ~/EPNro1/consolidar.pid)
		kill "$PID"
	fi

	rm -rf ~/EPNro1
	echo "Entorno eliminado."
	exit
fi

while true
do 
	echo "- - - M E N U - - -"
	echo "1. Crear entorno."
	echo "2. Correr proceso."
	echo "3. Mostrar listado de alumnos."
	echo "4. Mostrar las 10 notas mas altas."
	echo "5. Buscar por padron."
	echo "6. Visualizar log."
	echo "7. Salir."

	read -p "Ingrese una opcion: " opcion

	case $opcion in 
		1)
			mkdir -p ~/EPNro1/{entrada,salida,procesado}
			echo "Entorno creado con exito."
			cat << 'EOF' > ~/EPNro1/consolidar.sh
#!/bin/bash

while true
do
    for archivo in ~/EPNro1/entrada/*.txt
    do
        if [ -f "$archivo" ]; then

            cat "$archivo" >> ~/EPNro1/salida/${FILENAME}.txt

            mv "$archivo" ~/EPNro1/procesado/

            echo "$(date '+%d/%m/%Y %H:%M:%S') - Procesado archivo $(basename "$archivo")" >> ~/EPNro1/procesado.log

        fi
    done

    sleep 5
done
EOF
			chmod +x ~/EPNro1/consolidar.sh
			echo "Entorno creado con exito."
			;;

		2)
			~/EPNro1/consolidar.sh &
			echo "Proceso iniciado en segundo plano."
			echo $! > ~/EPNro1/consolidar.pid #Guardo el PID del proceso en background
			;;

		3)
			if [ -f "$HOME/EPNro1/salida/${FILENAME}.txt" ]; then
				sort -n "$HOME/EPNro1/salida/${FILENAME}.txt"
			else
				echo "El archivo no existe."
			fi
			;;

		4)
			if [ -f "$HOME/EPNro1/salida/${FILENAME}.txt" ]; then
				sort -k5,5nr "$HOME/EPNro1/salida/${FILENAME}.txt" | head -n 10
			else
				echo "El archivo no existe."
			fi
			;;

		5)
			if [ -f "$HOME/EPNro1/salida/${FILENAME}.txt" ]; then
				read -p "Ingrese el numero de padron: " padron
				grep "^$padron " ~/EPNro1/salida/${FILENAME}.txt 
			else
				echo "El numero de padron no existe."
			fi
			;;

		6)
			less ~/EPNro1/procesado.log
			;;

		7)
			echo "Saliendo..."
			break
			;;

		*)
			echo "Opcion invalida."
			;;

	esac

done
