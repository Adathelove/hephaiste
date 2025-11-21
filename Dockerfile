# --- base image ---
FROM node:20-alpine

# --- working directory inside container ---
WORKDIR /app

# --- copy package files first (for caching) ---
COPY package*.json ./

# --- install dependencies ---
RUN npm install --omit=dev

# --- copy the rest of your project ---
COPY . .

# --- ensure the CLI entrypoint is executable ---
RUN chmod +x index.js

# --- default command (lets you run hephaiste inside container) ---
ENTRYPOINT ["./index.js"]