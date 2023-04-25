```
git clone https://github.com/waynestate/base-site
./build.sh
./run.sh
```

Now, do development work locally on your machine and watch as the changes are reflected in the docker container and via the `make watch` command.

To view container information:
```
docker ps
```

To access a container, keep in mine that ports are mapped `LOCAL:REMOTE` meaning that `0.0.0.0:32678:3000` means you can access `localhost:32678` in a web browser and traffic destined for there will be sent to port 3000/tcp inside the container.
