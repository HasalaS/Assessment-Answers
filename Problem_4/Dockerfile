FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    nginx \
    curl \
    && pip install gunicorn

RUN curl -sSL https://deb.nodesource.com/setup_16.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g pm2 \
    && npm cache clean --force

WORKDIR /usr/src/app

COPY ./app/ .

RUN npm install

EXPOSE 3000

CMD service nginx start && pm2 start app.js --name "my-app" && pm2 logs
