require "open-uri"

puts "🌱 Seeding database..."

User.destroy_all

puts "🧹 Old records cleared!"

# === Users ===
users_data = [
  {
    name: "Gwen",
    lastname: "Stacy",
    profile_image: "https://sync-chat.s3.us-east-1.amazonaws.com/g.png",
    about: "",
    email: "stacy@example.com",
    password: "password1234"

  },
  {
    name: "Harry",
    lastname: "Osborn",
    profile_image: "https://sync-chat.s3.us-east-1.amazonaws.com/harry.jpg",
    about: "Goblin Junior",
    email: "goblin@example.com",
    password: "password1234"
  },
  {
    name: "bully",
    lastname: "Maguire",
    profile_image: "https://sync-chat.s3.us-east-1.amazonaws.com/bully-maguire.jpg",
    about: "I'm gonna put some dirt on your eyes!",
    email: "putssomedirt@mail.com",
    password: "password1234"

  },
  {
    name: "norman",
    lastname: "osborn",
    profile_image: "https://sync-chat.s3.us-east-1.amazonaws.com/norman.png",
    about: "I'm Right Here",
    email: "oscorp@example.com",
    password: "password1234"
  }
]

users = users_data.map do |u|
  user = User.create!(
    name: u[:name],
    email: u[:email],
    about: u[:about],
    lastname: u[:lastname],
    password: u[:password],

  )

  # Attach profile_image
  begin
    file = URI.open(u[:profile_image])
    user.profile_image.attach(io: file, filename: "#{u[:name].parameterize}.jpg", content_type: "image/jpeg")
  rescue OpenURI::HTTPError => e
    puts "⚠️ Failed to attach profile image for #{u[:name]}: #{e.message}"
  end

  user
end

puts "👤 Created #{User.count} users."
