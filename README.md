# Python3 Data Science Container
Dockerfile containing common Python3 packages used for Data Science

## Run
```
# Start interactive data science container
docker run --rm -it \
  --name py3ds \
  -v $HOME/data:/data \
  erikhoward/py3-disco /bin/bash
```

## Licence
MIT
