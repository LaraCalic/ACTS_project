docker run -p 8888:8888 --volume=$PWD:$PWD --workdir $PWD --interactive --name ExACTSBox --platform linux/amd64 --tty hherde/lund-acts:v2 /bin/bash 
