# Cloud Systems – Homework Summaries

## Homework 2 – Multi-Stage Container Build
A multi-stage Docker build was used to compile Hugo from source, apply custom modifications, and generate a static website. The final stage served the site using an unprivileged Nginx instance on port 8080. The generated site included a custom *about* page with Name and UCO, and the resulting image was pushed to the e-INFRA CZ Container Registry.

## Homework 4 – Terraform VM Deployment
A VM was deployed on the e-INFRA CZ OpenStack cloud using Terraform with declarative resources for the instance, network, security groups, key pair, and floating IP. A `user_data` script installed Apache2 and created a custom index page with Name and UCO. Terraform outputs exposed the VM’s public IP for verification over HTTP.
