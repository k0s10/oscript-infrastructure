server {
    listen 80;
    listen [::]:80;
    server_name api.oscript.io;

    location /.well-known/acme-challenge/ {
        root /var/www/certbot;
    }

    location / {
        return 302 https://$host$request_uri;
    }
}

server {
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    server_name api.oscript.io;
    root /var/www/api.oscript.io;

#    client_max_body_size 50M; Параметр имеет смысл указывать, если через nginx проходят файлы размера больше 1 Mb

    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header X-Download-Options noopen;
    add_header X-Permitted-Cross-Domain-Policies none;

    add_header Strict-Transport-Security "max-age=31536000" always;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;

    proxy_redirect off;

    location / {
#Куда перенаправляем запросы, например:
#        proxy_pass http://site:5000; 
    }

    include /etc/nginx/ssl_conf/options-ssl-nginx.conf;
    ssl_dhparam /etc/nginx/ssl_conf/ssl-dhparams.pem;
    ssl_certificate /etc/letsencrypt/live/api.oscript.io/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/api.oscript.io/privkey.pem;
}
