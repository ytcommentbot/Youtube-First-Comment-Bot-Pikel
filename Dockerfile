FROM python:3.10-slim

RUN apt-get update && apt-get install -y \
  curl gnupg unzip wget fonts-liberation libnss3 libatk-bridge2.0-0 xdg-utils \
  libasound2 libxcomposite1 libxdamage1 libxrandr2 libxtst6 libdbus-1-3 --no-install-recommends \
 && rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN curl -sSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor \
  -o /etc/apt/trusted.gpg.d/google.gpg \
 && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" \
  > /etc/apt/sources.list.d/google.list \
 && apt-get update && apt-get install -y google-chrome-stable

# Install ChromeDriver
RUN CHROME_VER=$(google-chrome --version | grep -oP "\d+\.\d+\.\d+") \
 && wget -O /tmp/chromedriver.zip \
  "https://storage.googleapis.com/chrome-for-testing-public/${CHROME_VER}.0/linux64/chromedriver-linux64.zip" \
 && unzip /tmp/chromedriver.zip -d /usr/local/bin \
 && rm /tmp/chromedriver.zip

WORKDIR /app
COPY . .
RUN pip install --no-cache-dir -r requirements.txt

CMD ["python", "webserver.py"]
