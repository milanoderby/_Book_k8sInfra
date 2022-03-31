#!/usr/bin/env bash
# create-tls.sh 파일 실행 후, 아래 작업을 수행해야합니다.
# NCloud 환경에서는 다른 노드로 SSH 및 SCP 통신이 불가하므로 수동으로 서버에 접속하여 위의 작업을 수행해줍니다.

# yum install sshpass -y
# for i in {1..3}
#   do
#     sshpass -p vagrant ssh -o StrictHostKeyChecking=no root@192.168.1.10$i mkdir -p $certs
#     sshpass -p vagrant scp tls.crt 192.168.1.10$i:$certs
#   done

certs=/etc/docker/certs.d/10.105.193.77:8443
cp tls.crt $certs
mv tls.* /etc/docker/certs

docker run -d \
  --restart=always \
  --name registry \
  -v /etc/docker/certs:/docker-in-certs:ro \
  -v /registry-image:/var/lib/registry \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/docker-in-certs/tls.crt \
  -e REGISTRY_HTTP_TLS_KEY=/docker-in-certs/tls.key \
  -p 8443:443 \
  registry:2
