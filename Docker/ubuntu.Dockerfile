FROM ubuntu:focal

RUN apt-get update && apt-get install -y \
  curl \
  && rm -rf /var/lib/apt/lists/*

CMD [ "/bin/bash", "-c", "--", "while true; do sleep 300; done;" ]
