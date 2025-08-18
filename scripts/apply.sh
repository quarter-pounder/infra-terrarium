#!/bin/bash
cd environments/dev
terraform init
terraform apply -auto-approve
