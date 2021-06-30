# Sprint-Name-Generator
[Sprint Name Generator](https://sprintnamegenerator.com)

Built by: 
- [Florian Stadler](https://github.com/flostadler) - Go -> Wasm
- [Wolfgang Ederer](https://github.com/wederer) - Frontend

## Usage
1. Start project: `docker-compose up -d --build`
2. [Sprint Name Generator with Docker compose](http://localhost)
3. Initiate blue/green deployment in local shell: `./blue-green-deployment.sh`
4. Follow process of deployment in shell
5. Reload [Sprint Name Generator with Docker compose](http://localhost)
6. Cleanup: `./docker-compose down -v --rmi all`

