init:
	cd terraform && terraform init

fmt:
	cd terraform && terraform fmt

validate:
	cd terraform && terraform validate

plan:
	cd terraform && terraform plan

apply:
	cd terraform && terraform apply

destroy:
	cd terraform && terraform destroy

app-test:
	cd app && npm install && npm test

docker-build:
	docker build -t devops-assignment-app:local ./app
