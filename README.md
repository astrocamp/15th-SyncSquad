# README

- run bundle install
- run yarn install
- run rails db:setup
- run bin/dev, and check http://localhost:5000
- Starting Redis
- Install ImageMagick and/or libvips:
  In a Mac terminal: $ brew install imagemagick vips
  In a debian/ubuntu terminal: $ sudo apt install imagemagick libvips

# Set Steps

- If run db:migrate failed run rails active_storage:install than run    db:migrate
