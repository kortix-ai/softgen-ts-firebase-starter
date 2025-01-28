# Build stage to clone template
FROM node:18-alpine AS builder

# Install git for cloning
RUN apk add --no-cache git

# Clone the template repository during image build
RUN git clone https://github.com/kortix-ai/softgen-ts-firebase-starter /template-files

# Remove .git directory to avoid conflicts
RUN rm -rf /template-files/.git

# Final stage
FROM node:18-alpine

# Metadata
LABEL maintainer="Softgen AI"
LABEL description="Softgen AI Starter"
LABEL version="1.0"

# Install global dependencies
RUN npm install -g pm2 vercel firebase-tools
RUN apk add --no-cache tmux git

# Copy template files from builder stage
COPY --from=builder /template-files /template-files

# Set up environment
ENV GOOGLE_APPLICATION_CREDENTIALS="/app/firebase-service-account.json"
EXPOSE 3000
WORKDIR /app

# Add initialization script
COPY init-workspace.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-workspace.sh

# Use initialization script as entrypoint
ENTRYPOINT ["/bin/sh", "-c", "/usr/local/bin/init-workspace.sh && sleep infinity"]


