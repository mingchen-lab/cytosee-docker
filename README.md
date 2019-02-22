# cytosee-docker
Docker image with CytoSEE

## Installation

### Build from dockerfile
```bash
# clone this repo 
git clone https://github.com/mingchen-lab/cytosee-docker.git
cd cytosee-docker
docker build -t cytosee --network host .
```
### pull from dockerhub
```bash
docker pull mchenlab/cytosee:latest
```

## Start a container
```bash
docker run -d -p 127.0.0.1:port:3838 mchenlab/cytosee:latest
## then open browser, CytoSEE can be avaiable at http://127.0.0.1:port
```
