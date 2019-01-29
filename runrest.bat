@echo off
echo %1
if .%1 == .xyz ( 
    echo Usage: runrest.bat ^<deployed DLL folder^> ^<container name^> ) else (
	docker run -v %1:c:\mabukavol -d -i --network="nat" --name %2 -p 16001:86/udp -p 16001:86/tcp -p 9000-9010:9000-9010 -p 9040-9050:9040-9050 microfocus/edbuildtools-rest:win_4.0
    echo IP Address of container is:
	docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" %2)	

