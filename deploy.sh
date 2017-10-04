#!/bin/bash
docker build -t alikhil/sample-node-with-ci .
docker push alikhil/sample-node-with-ci

ssh deploy@35.190.205.238 << EOF
docker pull alikhil/sample-node-with-ci:latest
docker stop web || true
docker rm web || true
docker rmi alikhil/sample-node-with-ci:current || true
docker tag alikhil/sample-node-with-ci:latest alikhil/sample-node-with-ci:current
docker run -d --net app --restart always --name web -p 80:80 alikhil/sample-node-with-ci:current
EOF
