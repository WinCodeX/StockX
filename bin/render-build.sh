#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install

# ./bin/rails assets:precompile
# ./bin/rails assets:clean

# echo "=== Dropping and Creating Database ==="
# bundle exec rails db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1 || true
# bundle exec rails db:create
      

echo "=== Seeding Test Data ==="
bundle exec rails db:seed

bin/rails db:migrate:up VERSION=20250530070004

bin/rails db:migrate:up VERSION=20250530070651

bin/rails db:migrate:up VERSION=20250530081845
#bin/rails db:migrate

bundle exec rails db:migrate 

echo "=== Build Complete Successfully ==="

#  bundle install; bundle exec rails assets:precompile; bundle exec rails assets:clean;