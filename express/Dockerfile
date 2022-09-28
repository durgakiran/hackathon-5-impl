FROM node:14

WORKDIR /usr/src/app

COPY package*.json ./

RUN apt-get update || : && apt-get install python -y

RUN npm install

COPY . .

EXPOSE 3007

CMD ["node", "server.js"]

