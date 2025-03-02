docker run -d --name sonarqube -p 9000:9000 sonarqube:lts-community

# e.g
# sonar-scanner \
#   -Dsonar.projectKey=demo \
#   -Dsonar.sources=. \
#   -Dsonar.host.url=http://localhost:9000 \
#   -Dsonar.login=sqp_9d3d82469f85d7c63d302ea32254e1d539d623e0
