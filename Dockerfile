FROM node:latest

WORKDIR /app

RUN git clone https://github.com/comunica/comunica.git
RUN cd /app/comunica && yarn install
RUN chmod 755 /app/comunica/packages/actor-init-sparql/bin/query.js
RUN ln -s /app/comunica/packages/actor-init-sparql/bin/query.js /usr/local/bin/comunica-sparql

COPY ./ldf-queries /app/ldf-queries
COPY ./ldf-instances.txt /app/ldf-instances.txt
COPY ./grlc-queries.txt /app/grlc-queries.txt
COPY ./grlc-instances.txt /app/grlc-instances.txt
COPY ./run-grlc.sh /app/run-grlc.sh
COPY ./run-ldf.sh /app/run-ldf.sh
COPY ./package-output.sh /app/package-output.sh
COPY ./run.sh /app/run.sh

CMD [ "./run.sh" ]
