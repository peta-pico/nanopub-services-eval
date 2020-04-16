FROM node:latest

WORKDIR /app

COPY ./queries ./queries
COPY ./ldf-instances.txt ./ldf-instances.txt
COPY ./run.sh ./run.sh

RUN git clone https://github.com/comunica/comunica.git
RUN cd /app/comunica && yarn install
RUN chmod 755 /app/comunica/packages/actor-init-sparql/bin/query.js
RUN ln -s /app/comunica/packages/actor-init-sparql/bin/query.js /usr/local/bin/comunica-sparql

CMD [ "./run.sh" ]
