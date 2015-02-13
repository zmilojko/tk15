puts "Creating two users and deleteting rest"
User.delete_all
User.create!  email: "katariina@z-ware.fi",
    password: "nellabella!",
    password_confirmation: "nellabella!",
    admin: true
User.create!  email: "zeljko@zwr.fi",
    password: "nellabella!",
    password_confirmation: "nellabella!",
    admin: false

