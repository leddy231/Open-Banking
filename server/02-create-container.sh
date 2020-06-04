docker stop backend || true && docker rm backend || true
docker create --name backend --restart unless-stopped --network host bankon/backend