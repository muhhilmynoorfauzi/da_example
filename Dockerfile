# Use the official Dart image
FROM cirrusci/flutter:stable AS build

# Set the working directory
WORKDIR /app

# Copy the pubspec and lock files
COPY pubspec.* ./

# Get dependencies
RUN flutter pub get

# Copy the source code
COPY . .

# Build the Flutter Web app
RUN flutter build web --release

# Use Nginx as the web server
FROM nginx:stable-alpine

# Copy the build output to the Nginx html directory
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
