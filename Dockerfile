FROM node:18-alpine AS build

WORKDIR /app
COPY . .

RUN npm i
RUN npm run build -s ASSERTIONS=1

CMD ["node", "build/."]

# FROM nginx:1.18-alpine AS deploy-static

# WORKDIR /usr/share/nginx/html
# RUN rm -rf ./*
# COPY --from=build /app/build .

# ENTRYPOINT ["nginx", "-g", "daemon off;"]


# FROM node:18-alpine as deploy-node

# WORKDIR /app
# # RUN rm -rf ./*
# COPY --from=build /app .
