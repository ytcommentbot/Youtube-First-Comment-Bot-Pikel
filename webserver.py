from flask import Flask
import threading, time
import bot  # main bot logic

app = Flask(__name__)

@app.route('/')
def home():
    return "✅ Bot is running!"

def loop_bot():
    while True:
        print("[BOT] checking feed...")
        try:
            bot.run_once()  # polls + comments
        except Exception as e:
            print("[ERROR]", e)
        time.sleep(30)  # check every 30 seconds

if __name__ == "__main__":
    t = threading.Thread(target=loop_bot, daemon=True)
    t.start()
    app.run(host="0.0.0.0", port=8080)
