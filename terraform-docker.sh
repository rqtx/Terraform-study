#!/bin/bash

# Após iniciar o container lembre-se de criar as Variáveis de Ambiente para acessar o provedor cloud
# AWS
# export AWS_ACCESS_KEY_ID=
# export AWS_SECRET_ACCESS_KEY=

docker run -it -v $PWD/examples:/app -w /app --entrypoint "" hashicorp/terraform:light sh
