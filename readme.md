# Sprint-Name-Generator

Built by: 
- [Florian Stadler](https://github.com/flostadler) - Go -> Wasm
- [Wolfgang Ederer](https://github.com/wederer) - Frontend
# Sprint-Name-Generator blue/green with docker-compose
- [Ivan Jenkac](https://github.com/ijenkac)
## Usage
1. Start project: `docker-compose up -d --build`
2. Open in browser [Sprint Name Generator from docker-compose environment](http://localhost)
3. Initiate blue/green deployment in local shell: `./blue-green-deployment.sh`
4. Follow process of deployment in shell
5. Reload [Sprint Name Generator from docker-compose environment](http://localhost)
6. Check bottom of the page with new code revision deployed
7. Cleanup: `docker-compose down -v --rmi all`

