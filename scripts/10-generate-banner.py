#!/usr/bin/env python3

import os
import sys
import configparser
import glob

from datetime import datetime
from time import strptime

import pytz

from PIL import Image, ImageDraw, ImageFont


def get_asset(file: str):
    cwd = os.path.dirname(os.path.realpath(sys.argv[0]))
    return os.path.join(cwd, "..", "assets", "banner.png", file)


def overlay_retirement_date(img: Image):
    seoul_timezone = pytz.timezone('Asia/Seoul')

    # Find out how many days left until retirement
    config = configparser.ConfigParser()
    config.read(get_asset("settings.conf"))

    enlistment_date = datetime(
        *strptime(config['data']['enlistment_date'], "%Y-%m-%d")[0:6],
        tzinfo=seoul_timezone
    )
    retirement_date = datetime(
        *strptime(config['data']['retirement_date'], "%Y-%m-%d")[0:6],
        tzinfo=seoul_timezone
    )
    current_date = datetime.now(seoul_timezone)

    # If not serving anymore, skip the whole thing
    if current_date > retirement_date:
        return

    # Setup a drawing object
    draw = ImageDraw.Draw(img)
    draw.fontmode = "0"

    # Register fonts
    font_36pt = ImageFont.truetype(
        get_asset("neodgm.ttf"),
        size=36,
        layout_engine=ImageFont.LAYOUT_BASIC
    )
    font_60pt = ImageFont.truetype(
        get_asset("neodgm.ttf"),
        size=60,
        layout_engine=ImageFont.LAYOUT_BASIC
    )

    # Write the texts
    draw.text((30, 390),
              "Serving in the RoK Navy...",
              (255, 255, 255),
              font=font_36pt)

    # Figure out the right thing to say
    message = None

    if current_date < enlistment_date:
        days_left = (enlistment_date - current_date).days
        if days_left == 1:
            message = f"{days_left} day left as a civilian"
        else:
            message = f"{days_left} days left as a civilian"
    else:
        days_served = (current_date - enlistment_date).days
        total_days = (retirement_date - enlistment_date).days
        message = f"{days_served} of {total_days} days served!"

    draw.text(
        (30, 435),
        message,
        (255, 166, 76),
        font=font_60pt
    )


def generate_banner():
    # Create base background
    banner_background = Image.open(get_asset("banner-background.png"))
    banner_background = banner_background.resize((1024, 512), Image.NEAREST)
    overlay_retirement_date(banner_background)

    banner_files = [get_asset(f"banner_{frame:04d}.png") for frame in range(0, 22)]

    # The glob match is not sorted, apparently
    banner_files.sort()

    # List of PIL image frames
    processed_frames = []

    for file in banner_files:
        try:
            # Load a frame
            frame = Image.open(file)

            # Fix the yellow-ish "background" by clamping any transparent pixels
            width, height = frame.size
            for x in range(width):
                for y in range(height):
                    r, g, b, a = frame.getpixel((x, y))
                    if a < 255:
                        frame.putpixel((x, y), (0, 0, 0, 0))

            # Resize the image
            frame = frame.resize((1024, 512), Image.NEAREST)

            # Alpha-composite and add the image to the list
            processed_frames.append(
                Image.alpha_composite(banner_background, frame)
            )

        except Exception as e:
            print("An exception occurred:", e)
            print(f"Unable to process {file}! Skipping the frame...")
            print()

    processed_frames[0].save(
        "banner.png",
        format="PNG",
        save_all=True,
        append_images=processed_frames[1:],
        duration=100,
        loop=0
    )


if __name__ == "__main__":
    generate_banner()
