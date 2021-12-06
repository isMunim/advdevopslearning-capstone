FROM launcher.gcr.io/google/nodejs
COPY . /external-app/
WORKDIR /external-app
RUN npm install
CMD ["node", "server.js"]