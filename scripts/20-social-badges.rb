#!/usr/bin/env ruby

# frozen_string_literal: true

SOCIAL_PROFILES = [
  {
    :name => 'Instagram',
    :url => 'https://www.instagram.com/rangho_lee',
    :background => 'E4405F',
    :foreground => 'white',
  },
  {
    :name => 'Email',
    :url => 'mailto:hello@rangho.me',
    :icon => 'Gmail',
    :background => 'EA4335',
    :foreground => 'white',
  },
  {
    :name => 'Reddit',
    :url => 'https://www.reddit.com/user/rangho-lee',
    :background => 'FF4500',
    :foreground => 'white',
  },
  {
    :name => 'KakaoTalk',
    :url => 'https://open.kakao.com/o/s9KDhU5c',
    :background => 'FFCD00',
    :foreground => '3A1D1D',
  },
  {
    :name => 'Line',
    :url => 'https://line.me/ti/p/~zu0107',
    :background => '00C300',
    :foreground => 'white',
  },
  {
    :name => 'Telegram',
    :url => 'https://t.me/rangho_lee',
    :background => '26A5E4',
    :foreground => 'white',
  },
  {
    :name => 'Bluesky',
    :url => 'https://bsky.app/profile/bsky.rangho.moe',
    :background => '0285FF',
    :foreground => 'white',
  },
  {
    :name => 'LinkedIn',
    :url => 'https://www.linkedin.com/in/juhun-lee-4a1ba2114/',
    :background => '0A66C2',
    :foreground => 'white',

  },
  {
    :name => 'Discord',
    :url => 'https://discord.com/users/220386972189982721',
    :background => '7289DA',
    :foreground => 'white',
  },
  {
    :name => 'Twitch',
    :url => 'https://www.twitch.tv/rangho',
    :background => '9146FF',
    :foreground => 'white',
  },
]

badges = SOCIAL_PROFILES.map do |profile|
  "[![#{profile[:name]}](https://img.shields.io/badge/-#{profile[:name]}-#{profile[:background]}?style=flat-square&logo=#{(profile[:icon] || profile[:name]).downcase}&logoColor=#{profile[:foreground]})](#{profile[:url]})"
end

original_readme = File.read 'README.md'
new_readme = original_readme.gsub(/<!-- REPLACE WITH social_badges -->/, badges.join("\n"))

File.open('README.md', 'w') { |file| file.puts new_readme }
