# Dicoding Microservices Submission 1: Proyek Deploy Aplikasi Item App dengan Docker Compose

## Objective

1. Start by forking [this repository](https://github.com/dicodingacademy/a433-microservices/tree/proyek-pertama) and cloning the application from the "proyek-pertama" branch.

2. Create a Dockerfile for the application with the following specifications:
   - Use Node.js version 14 as the base image.
   - Set the container's working directory to /app.
   - Copy all source code to the container's working directory.
   - Set the `NODE_ENV` environment variable to "production" and the `DB_HOST` environment variable to "item-db."
   - Install production dependencies and build the application.
   - Expose port 8080 for the application.
   - Upon container launch, execute the command "npm start."

4. Develop a script named `build_push_image.sh` with the following functionality:
   - Build a Docker image from the Dockerfile with the name "item-app" and tag it as "v1."
   - List local Docker images.
   - Rename the image to match the GitHub Packages format.
   - Log in to GitHub Packages via the Terminal.
   - Push the image to GitHub Packages.

5. Create a `docker-compose.yml` file with the following configurations:
   - Use Docker Compose version 2.
   - Define two services: "item-app" and "item-db."
     1. For "item-app":
         - Use the "item-app" image from GitHub Packages.
         - Map port 80 on the host to port 8080 in the container.
         - Ensure that "item-app" only starts after "item-db" is launched.
         - Use "always" as the restart policy.
     2. For "item-db":
         - Use the "mongo:3" image from Docker Hub.
         - Use a volume named "app-db" with a target of "/data/db" in the container.
         - Use "always" as the restart policy.
   - Define a volume named "app-db."

6. Include a `log.txt` file containing logs generated while using Docker Compose.

7. Ensure the GitHub Packages image is publicly accessible.

## Solution

### 1. Project Setup

1. Fork the repository to your personal GitHub account.

    ![Screenshot 2023-09-12 at 16.33.44.png](_resources/Screenshot%202023-09-12%20at%2016.33.44.png)

2. Clone the "proyek-pertama" branch from the forked repository.

   ```bash
   git clone https://github.com/<Your GitHub Username>/a433-microservices.git -b proyek-pertama proyek-pertama
   ```

3. Create a GitHub personal access token with the "write:packages" access scope for pushing an image to GitHub Packages by following these steps:

   1. Visit [GitHub Personal Access Tokens](https://github.com/settings/tokens) webpage, and click "Generate new token" -> "Generate new token (classic)" to create a new token.

      ![Screenshot 2023-09-16 at 09.16.28.png](_resources/Screenshot%202023-09-16%20at%2009.16.28.png)

   2. Give the token a name by filling the "Note" field. Then check the "write:packages" access scope to give the token the permission.

      ![Screenshot 2023-09-16 at 09.23.20.png](_resources/Screenshot%202023-09-16%20at%2009.23.20.png)

   3. Scroll down to the bottom of the webpage and click the "Generate token" button. Copy the value generated.

      ![Screenshot 2023-09-16 at 09.25.32.png](_resources/Screenshot%202023-09-16%20at%2009.25.32.png)

4. Set "GH_PACKAGES_TOKEN" environment variable with the previously generated access token. 
   ```bash
   export GH_PACKAGES_TOKEN=<GitHub Packages Token>
   ```
5. Install [Docker Desktop](https://www.docker.com/products/docker-desktop/).

### 2. Building and Pushing the Application Image

1. Go to the application folder.
   ```
   cd <Project Root Directory>
   cd proyek-pertama
   ```
2. Create a Dockerfile.

   ```bash
   nano Dockerfile
   ```

   Copy and paste the following content:

   ```Dockerfile
   # Use Node.js version 14 as the base image
   FROM node:14

   # Set the working directory for the container
   WORKDIR /app

   # Copy all source code to the working directory in the container
   COPY . .

   # Ensure the application runs in production mode and uses "item-db" as the database host
   ENV NODE_ENV=production DB_HOST=item-db

   # Install production dependencies and build the application
   RUN npm install --production --unsafe-perm && npm run build

   # Expose port 8080 used by the application
   EXPOSE 8080

   # When the container is launched, execute the command "npm start"
   CMD ["npm", "start"]
   ```

3. Create the "build_push_image.sh" file.

   ```bash
   nano build_push_image.sh
   ```

   Copy and paste the following content:

   ```bash
   #!/bin/bash

   # Build a Docker image from the Dockerfile
   docker build -t item-app:v1 .

   # List local Docker images
   docker images

   # Rename the image to match GitHub Packages format
   docker tag item-app:v1 ghcr.io/<Your GitHub Username>/item-app:v1

   # Log in to GitHub Packages
   echo $GH_PACKAGES_TOKEN | docker login ghcr.io -u <Your GitHub Username> --password-stdin

   # Push the image to GitHub Packages
   docker push ghcr.io/<Your GitHub Username>/item-app:v1
   ```

4. Execute the "build_push_image.sh" file.

   ```bash
   bash build_push_image.sh
   ```

5. Navigate to your GitHub account webpage and see the pushed image under the "Packages". 

   ![Screenshot 2023-09-16 at 09.43.53.png](_resources/Screenshot%202023-09-16%20at%2009.43.53.png)

6. Adjust the visibility to public to fulfill the assignment requirements by doing these steps:
   1. Click the name of the image
   2. Click the "Package settings"
   3. Scroll down to the "Danger Zone" panel and click the "Change visibility" button 
   4. Select public under the Change visibility pop up. Then type the name of the image in the provided field and click the "I understand the consequent, change package visibility" button.

   The "private" label beside the image name should be hidden now.

### 3. Deploying the App with Docker Compose

1. Create the "

docker-compose.yml" file.

   ```bash
   nano docker-compose.yml
   ```

   Copy and paste the following content:

   ```yaml
   version: '2'

   services:
     # Service for the item-app application
     item-app:
       image: ghcr.io/<Your GitHub Username>/item-app:v1
       ports:
         - "80:8080"  # Map port 80 on the host to port 8080 in the container
       depends_on:
         - item-db  # Ensure that "item-db" is running before starting "item-app"
       restart: always  # Set the container restart policy to always

     # Service for the item-db database
     item-db:
       image: mongo:3
       volumes:
         - app-db:/data/db  # Use the "app-db" volume to store database data

   volumes:
     app-db:  # Define the "app-db" volume
   ```

2. Implement the "docker-compose.yml" file to run containers.

   ```bash
   docker compose up -d
   ```

3. You should see both the item-app and item-db service containers are running.

   ```bash
   docker ps
   ```

   ![Screenshot 2023-09-16 at 10.12.13.png](_resources/Screenshot%202023-09-16%20at%2010.12.13.png)

4. Log the execution result of Docker Compose and save it in "log.txt."

   ```bash
   docker compose logs > log.txt
   ```

5. Check the application by visiting `localhost:80` on a web browser.

    ![Screenshot%202023-09-19%20at%2007.34.40.png](_resources/Screenshot%202023-09-19%20at%2007.34.40.png)

   Add more data on the app to test correct integration with the database by entering values in the input field and clicking the "Tambahkan" button. You should see the added item in the list.

    ![Screenshot%202023-09-12%20at%2018.06.47.png](_resources/Screenshot%202023-09-12%20at%2018.06.47.png)