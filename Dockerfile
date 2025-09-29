FROM nginx:latest
USER root
EXPOSE 22
ENV SUPER_SECRET_API_KEY="fak-eKeyForTrivyDemo_sk_123abc789xyz"
COPY index.html /usr/share/nginx/html
