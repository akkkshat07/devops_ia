# 1. Using a vague 'latest' tag is a bad practice.
# Trivy will flag this as a potential risk (DS013).
FROM nginx:latest

# 2. Running as the root user is the default and a major security risk.
# Trivy will detect this and recommend running as a non-root user.
USER root

# 3. Exposing the SSH port is unnecessary and increases the attack surface.
# Trivy will flag this as a high-severity misconfiguration (DS019).
EXPOSE 22

# 4. Adding a hardcoded secret directly into the image is a critical mistake.
# Trivy's secret scanner will find this key.
ENV SUPER_SECRET_API_KEY="fak-eKeyForTrivyDemo_sk_123abc789xyz"

# Copy the static web page content
COPY index.html /usr/share/nginx/html
