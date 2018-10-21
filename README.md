# IdWerk

## Devlopment

1. Create the key and certificate
```
mkdir -p priv/tmp/certs

openssl req \
    -x509 -days 365 -nodes -newkey rsa:2048 -keyout priv/tmp/certs/idwerk-jwt-key.pem \
    -out priv/tmp/certs/rootcertbundle.pem \
    -subj "/C=DE/ST=Berlin/L=Prenzelberg/O=IdWerk Auth/CN=registry.local"

```

2. Adjust the key in `config/dev.exs` (if you changed the `idwerk-jwt-key.pem` path)

3. Point `registry.local` to your `localhost` (in `/etc/hosts`)

4. Run the code
```
mix deps.get #remove _build deps directories, if you have compiled the project in your main OS
docker-compose up #keep it running or use -d
docker-compose logs -f #wait until the project and dependencies are compiled
docker-compose exec idwerk.local mix do ecto.create, ecto.migrate
docker-compose exec idwerk.local mix run priv/repo/seeds.exs
```

5. Login to docker (checkout the user & password from `seeds.exs`)
```
docker login -u <username> -p <password> registry.local:5000
```

6. Build and image and push it to docker

```
docker push registry.local:5000/<image-name>
```
