# README

# Sync-Chat

Sync-Chat is a real-time chat web application built with Rails 8 and Hotwire, providing seamless, responsive messaging
with modern web technologies.



https://github.com/user-attachments/assets/be6e03ef-f417-4d21-b036-dc69145e004b



# Features

Real-time messaging with Turbo Streams

User authentication and profile management

Profile image uploads stored in AWS S3

Postgres as the database for reliability and scalability

Dockerized development environment for easy setup

# Tech Stack

Backend: Ruby on Rails 8

Frontend: Hotwire (Turbo + Stimulus)

Database: Postgres

File Storage: AWS S3 (profile images)

Development Environment: Docker (only for dev)

# Installation

Ruby >= 3.x

Rails 8

Postgres

Docker (for dev environment only)

# Setup

Clone the repository:

    git clone https://github.com/your-username/sync-chat.git
    cd sync-chat

Install dependencies:

    bundle install

Configure database:

    rails db:create db:migrate

Start the Rails server:

    rails server

For development with Docker:

    bin/docker-dev up

# Usage

Register a new account or log in

Upload your profile image

Start chatting in real-time with other users

# License

Apache License 2.0

