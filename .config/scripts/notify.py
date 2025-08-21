import asyncio
import subprocess
import os
from aiohttp import ClientSession
from aiontfy import Ntfy, Event, Notification

TOPICS = ["android-notifications"]
NTFY_URL = "https://ntfy.voidarc.co.uk"

def send_notification(ntfy_notif: Notification):
    title = ntfy_notif.title or "ntfy"
    message = ntfy_notif.message or ""
    subprocess.Popen(["notify-send", "-i", "phone", title, message])
    os.system("pw-cat -p ~/.local/share/sounds/notif.mp3")

async def main():
    async with ClientSession() as session:
        ntfy = Ntfy(NTFY_URL, session)

        def callback(ntfy_notif: Notification):
            if ntfy_notif.event is Event.MESSAGE:
                send_notification(ntfy_notif)

        await ntfy.subscribe(
            TOPICS,
            callback,  # this is now a regular function
        )

if __name__ == "__main__":
    asyncio.run(main())

