# Dicoding Microservices Submission 1: Proyek Deploy Aplikasi Item App dengan Docker Compose

## Objective

1. Begin by forking [this repository](https://github.com/dicodingacademy/a433-microservices/tree/proyek-pertama), including all its branches, to your GitHub account.

2. Clone the application from the "proyek-pertama" branch.

3. Within the project folder, create a Dockerfile with the following specifications:
   - Utilize Node.js version 14 as the base image.
   - Set the working directory for the container to /app.
   - Copy all source code to the container's working directory.
   - Ensure the application runs in production mode and uses the "item-db" container as the database host.
   - Install production dependencies and build the application.
   - Expose port 8080 for the application.
   - Upon container launch, execute the command "npm start".

4. Develop a script named "build_push_image.sh" with the following functionality:
   - Build a Docker image from the Dockerfile with the name "item-app" and tag it as "v1".
   - List local Docker images.
   - Rename the image to match the GitHub Packages format.
   - Log in to GitHub Packages via the Terminal.
   - Push the image to GitHub Packages.

5. Formulate a "docker-compose.yml" file with the following configurations:
   - Use Docker Compose version 2.
   - Define two services: "item-app" and "item-db".
     1. For "item-app":
         - Use the "item-app" image from GitHub Packages.
         - Map port 80 on the host to port 8080 in the container.
         - Ensure that "item-app" only starts after "item-db" is launched.
         - Use "always" as the restart policy.
     2. For "item-db":
         - Use the "mongo:3" image from Docker Hub.
         - Use a volume named "app-db" with a target of "/data/db" in the container.
         - Use "always" as the restart policy.
   - Define a volume named "app-db".

6. Include a `log.txt` file containing logs generated while using Docker Compose.

7. Add explanatory comments in each created script.

8. Ensure the GitHub Packages image is publicly accessible.

## Solution

### 1. Setting Up the Project

1. Fork the repository to your personal GitHub account.

    <img src="_resources/Screenshot%202023-09-12%20at%2016.33.44.png" width="75%"/>

2. Clone the "proyek-pertama" branch from the forked repository and navigate to the project folder.

   ```bash
   git clone https://github.com/lareza-farhan-wanaghi/a433-microservices.git -b proyek-pertama proyek-pertama
   ```

3. Creata a GitHub personal access token for pushing an image to the GitHub Packages by following these steps:

   1. Visit [GitHub Personal Access Tokens](https://github.com/settings/tokens) webpage, and click "Generate new token" -> "Generate new token (classic)" to create a new token.

      <img src="_resources/Screenshot 2023-09-16 at 09.16.28.png" width="75%"/>

   2. Give the token a name by filling the "Note" field. Then check the "write:packages" access scope to give the token the permission.

      <img src="_resources/Screenshot 2023-09-16 at 09.23.20.png" width="75%"/>

   3. Scroll down to the bottom of the webpage and click the "Generate token" button. Copy the value generated.

      <img src="_resources/Screenshot 2023-09-16 at 09.25.32.png" width="75%"/>

4. Set "GH_PACKAGES_TOKEN" environment variable with the previously generated access token. 
   ```bash
   export GH_PACKAGES_TOKEN=<GitHub Token with Writing Packages Permission>
   ```


### 2. Creating the Dockerfile and build_push_image.sh files
1. Go to the the application folder.
   ```
   cd proyek-pertama
   ```
1. Create a Dockerfile.

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

2. Create the "build_push_image.sh" file.

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
   docker tag item-app:v1 ghcr.io/lareza-farhan-wanaghi/item-app:v1

   # Log in to GitHub Packages
   echo $GH_PACKAGES_TOKEN | docker login ghcr.io -u lareza-farhan-wanaghi --password-stdin

   # Push the image to GitHub Packages
   docker push ghcr.io/lareza-farhan-wanaghi/item-app:v1
   ```

### 3. Building and Pushing a Container Image using the build_push_image.sh file
1. Execute the "build_push_image.sh" file.

   ```bash
   bash build_push_image.sh
   ```

2. Navigate to your GitHub account webpage and see the pushed image under the "Packages". 

   <img src="_resources/Screenshot 2023-09-16 at 09.43.53.png" width="75%"/>

3. Adjust the visibility to public to fulfill the assignment requirements by doing these steps:
   1. Click the name of the image
   2. Click the "Package settings"
   3. Scroll down to the "Danger Zone" panel and click the "Change visibility" button 
   4. Select public under the Change visibility pop up. Then type the name of the image in the provided field and click the "I understand the consequent, change package visibility" button.

   The "private" label beside the image name should be hidden now.

### 3. Running Containers with Docker Compose and Retrieving Logs

1. Create the "docker-compose.yml" file.

   ```bash
   nano docker-compose.yml
   ```

   Copy and paste the following content:

   ```yaml
   version: '2'

   services:
     # Service for the item-app application
     item-app:
       image: ghcr.io/lareza-farhan-wanaghi/item-app:v1
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

   <img src="_resources/Screenshot 2023-09-16 at 10.12.13.png" width="75%"/>

3. Log the execution of Docker Compose and save the logs in "log.txt".

   ```bash
   docker compose logs > log.txt
   ```

### 4. Testing the Application

1. Visit the IP address of the application on port 80 using a web browser. (The screenshot below shows the application with some data that has been added.)

    <img src="_resources/Screenshot%202023-09-12%20at%2018.04.51.png" width="75%"/>

2. Add more data to test the database functionality by entering values in the input field and clicking the "Tambahkan" button.

    <img src="_resources/Screenshot%202023-09-12%20at%2018.06.37.png" width="75%"/>

3. You should now see the added item in the list.

    <img src="_resources/Screenshot%202023-09-12%20at%2018.06.47.png" width="75%"/>