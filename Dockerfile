# Menggunakan Flutter stable terbaru sebagai tahap build
FROM cirrusci/flutter:stable AS build

# Set environment variable
ENV FLUTTER_WEB=true

# Buat folder kerja
WORKDIR . .

# Salin pubspec dan pubspec.lock terlebih dahulu
COPY pubspec.yaml pubspec.lock ./

# Install dependencies
RUN flutter pub get

# Salin seluruh source code proyek Flutter ke dalam image
COPY . .

# Build aplikasi Flutter untuk web
RUN flutter build web --web-renderer html

# Tahap kedua untuk menyajikan aplikasi menggunakan server web ringan
FROM nginx:alpine

# Salin hasil build Flutter web ke direktori yang digunakan oleh Nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80 untuk akses ke aplikasi Flutter
EXPOSE 80

# Jalankan Nginx untuk menyajikan aplikasi
CMD ["nginx", "-g", "daemon off;"]