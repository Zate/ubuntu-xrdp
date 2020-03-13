docker_build:
		docker build -t zate75/bastion:base .
bast:
		cd bastion
		docker build -t zate75/bastion:latest .
		cd ..
mysql:
		cd guac
		docker build -t zate75/bastion:mysql .
		cd ..
full:
		make mysql
		make bast
		make docker_build