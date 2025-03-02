# Schools route finder MULTIBALL version

## Get hacking

Install Docker (or equivalent, e.g. Podman)

Do this:

```
docker build --tag adamdennet --platform=linux/amd64 .
docker run --platform=linux/amd64 -it -p 8081:3838 localhost/adamdennet
```

Visit http://localhost:8081/bh_school_choice
