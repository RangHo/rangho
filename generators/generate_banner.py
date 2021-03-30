#!/usr/bin/env python3

import os
import sys
import configparser
import glob

from datetime import datetime
from time import strptime

import pytz

from PIL import Image, ImageDraw, ImageFont


def get_resource(file: str):
    cwd = os.path.dirname(os.path.realpath(sys.argv[0]))
    return os.path.join(cwd, "..", "resources", file)


def get_asset(file: str):
    cwd = os.path.dirname(os.path.realpath(sys.argv[0]))
    assets_dir = os.path.join(cwd, "..", "assets")

    if not os.path.exists(assets_dir):
        os.mkdir(assets_dir)

    return os.path.join(assets_dir, file)


def overlay_retirement_date(img: Image):
    seoul_timezone = pytz.timezone('Asia/Seoul')

    # Find out how many days left until retirement
    config = configparser.ConfigParser()
    config.read(get_resource("settings.conf"))

    retirement_date = datetime(
        *strptime(config['data']['retirement_date'], "%Y-%m-%d")[0:6],
        tzinfo=seoul_timezone
    )
    current_date = datetime.now(seoul_timezone)

    days_left = (retirement_date - current_date).days

    # If not serving anymore, skip the whole thing
    if days_left < 0:
        return

    # Setup a drawing object
    draw = ImageDraw.Draw(img)
    draw.fontmode = "0"

    # Register fonts
    font_36pt = ImageFont.truetype(
        get_resource("neodgm.ttf"),
        size=36,
        layout_engine=ImageFont.LAYOUT_BASIC
    )
    font_72pt = ImageFont.truetype(
        get_resource("neodgm.ttf"),
        size=72,
        layout_engine=ImageFont.LAYOUT_BASIC
    )

    # Write the texts
    draw.text((30, 390),
              "Serving in the RoK Navy...",
              (255, 255, 255),
              font=font_36pt)
    draw.text((30, 425),
              # Fixing grammar because reasons
              f"{days_left} days left" if days_left > 1 else "just a day left!",
              (255, 166, 76),
              font=font_72pt)


def generate_banner():
    banner_files = glob.glob(get_resource("banner/*"))

    # The glob match is not sorted, apparently
    banner_files.sort()

    # List of PIL image frames
    processed_frames = []

    for file in banner_files:
        try:
            # Read image file
            frame = Image.open(file)

            # Upscale the image
            frame = frame.resize((1024, 512), Image.NEAREST)

            # Draw D-day text
            overlay_retirement_date(frame)

            # Add the image to the list
            processed_frames.append(frame)

        except Exception as e:
            print(e)
            print(f"Unable to process {file}! Skipping the frame...")

    processed_frames[0].save(get_asset("banner.png"),
                             format="PNG",
                             save_all=True,
                             append_images=processed_frames[1:],
                             duration=100,
                             loop=0)


if __name__ == "__main__":
    generate_banner()
