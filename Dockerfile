FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install --production

COPY app.js ./

EXPOSE 8080

ENV PORT=8080
ENV NODE_ENV=development

CMD ["npm", "start"]