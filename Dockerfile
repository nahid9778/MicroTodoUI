# Stage 1: Build the React app
FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

ARG REACT_APP_GET_TASKS_API_BASE_URL=http://localhost:8001
ARG REACT_APP_DELETE_TASK_API_BASE_URL=http://localhost:8002
ARG REACT_APP_CREATE_TASK_API_BASE_URL=http://localhost:8003
ENV REACT_APP_GET_TASKS_API_BASE_URL=$REACT_APP_GET_TASKS_API_BASE_URL
ENV REACT_APP_DELETE_TASK_API_BASE_URL=$REACT_APP_DELETE_TASK_API_BASE_URL
ENV REACT_APP_CREATE_TASK_API_BASE_URL=$REACT_APP_CREATE_TASK_API_BASE_URL

RUN npm run build

# Stage 2: Serve the production build
FROM nginx:alpine

COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80
