FROM node:18-alpine AS build

WORKDIR /app

COPY . .

# RUN npm install && npm run build
RUN npm install

# Add Non-root user
RUN useradd -m myuser
USER myuser

EXPOSE 80

CMD ["npm", "run", "dev", "--", "--port=${PORT:80}"]
