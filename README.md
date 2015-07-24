# docker-reicast

This is a simple Dockerfile and build script to cleanly build and package the latest git HEAD of Reicast.

This will typically leave you with a neat tarball and Debian package containing the latest Reicast binary.

At the moment this will only build x86_64 ELF binaries reliably, but I've previously easily gotten 32-bit binaries packaged using this method. I'll eventually split the two, rather than shimming both 32-bit and 64-bit build environments into the same image.

Build image (create build environment)

```
git clone git@github.com:chrisfu/docker-reicast.git
cd docker-reicast
docker build -t reicast-build .
```

Run a container from the image (build latest Reicast git HEAD within build environment)

```
docker run -it reicast-build
```

Once that's done, just pull the tarball and/or packages out of the container using 'docker cp' from the location that it gives you in stdout. If you're not attached to your container whilst Reicast is building, to get the tarball/package locations, just use:

```
docker logs --tail=10 <container_id>
```

The command above will simply show you the last 10 lines of stdout from the build process. The tarball and package locations will be at the very end of the output.
