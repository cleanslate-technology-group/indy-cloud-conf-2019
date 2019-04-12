FROM node:10.15.3-alpine

WORKDIR /usr/app

COPY ./package.json ./package-lock.json ./
RUN npm install --quiet

COPY . .

RUN npm run build

EXPOSE 8080

CMD ["npm", "run", "start"]
