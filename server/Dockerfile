FROM node:12-alpine
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json /app/package.json
RUN npm install
COPY . /app
EXPOSE 8000
CMD ["node", "main.js"]
