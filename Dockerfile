# base image with just our source files
FROM node:latest as BASE
WORKDIR /app
COPY . .
EXPOSE 1337
CMD ["node", "index.js"]
