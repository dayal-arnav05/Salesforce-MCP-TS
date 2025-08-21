# Use Node.js 18 Alpine for smaller image size
FROM node:22-alpine
# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Copy source code
COPY . .

# Install dependencies
RUN npm ci

# Build the application
RUN npm run build

# Expose port
EXPOSE 3000

# Start the application
CMD ["node", "dist/index.js"]