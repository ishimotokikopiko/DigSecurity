
FROM node:16.6.0-alpine

# Set defaults environment variables.
ENV APP_HOST="0.0.0.0"
ENV APP_PORT="3000"
ENV PATH="${HOME_APP}/.local/bin:$PATH"

# Add a work directory
WORKDIR /opt/app

# Copy app files to docker.
COPY package.json .
COPY package-lock.json .
COPY . .

# Install node requirements.
RUN npm install

# Start the app
EXPOSE ${APP_PORT}
CMD [ "npm", "start" ]