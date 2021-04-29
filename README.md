# PasswordExample

NOTE: This repo is meant for a demonstration. It does not illustrate good security.

## Demo Instructions

1. Go to `/admin` and change the hashing type to `plaintext`
   - Have people make a new account. Warn them that everyone will be able to see their name and password.
   - Have people go to `/hack` so they can pretend to be a hacker and view the passwords database
   - Explain why it's bad that the attacker can see everyone's passwords
2. Explain what a hashing algorithm is (use an online SHA-1 calculator as an example). In `/admin`, delete the existing users, then change the hashing type to `sha1`.
   - Have people reload the page so they're logged out, then create a new account. Make sure there are 2 people who use the same password, and make sure someone uses a really common password.
   - This is an improvement, since the hacker can't see the passwords right away, but they can just go through a list of common passwords, hash them all, and see which of them are in the database. For common passwords, they can even just Google the hash and they'll get the original password.
3. Explain what a salt is. In `/admin`, delete the existing users, then change the hashing type to `sha1_with_salt`.
   - Have people reload the page so they're logged out, then create a new account. Make sure there are 2 people who use the same password, and make sure someone uses a really common password.
   - This is an improvement, since 2 people with the same password won't have the same hash, and you can't just Google the SHA-1 hash. It's more work for the attacker, since they need to try hashing common passwords for each person individually, rather than finding all the common passwords in the database in one pass.
   - Ask about the length of time that it took to hash their passwords (people can see this on their home page when they log in). Is it a good thing or a bad thing that the password hashing algorithm is super fast? Bad because it makes it easy to crack.
4. In `/admin`, delete the existing users, then change the hashing type to `argon2id`.
   - Have people reload the page so they're logged out, then create a new account. Make sure there are 2 people who use the same password, and make sure someone uses a really common password.
   - `argon2id` seems to be considered the best password hashing algorithm right now (`bcrypt` is good, but apparently not as good).

## To start your the Phoenix server:

- Install the Elixir programming language
- Install dependencies with `mix deps.get`
- Create and migrate your database with `mix ecto.setup`
- Install Node.js dependencies with `npm install` inside the `assets` directory
- Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

- Official website: https://www.phoenixframework.org/
- Guides: https://hexdocs.pm/phoenix/overview.html
- Docs: https://hexdocs.pm/phoenix
- Forum: https://elixirforum.com/c/phoenix-forum
- Source: https://github.com/phoenixframework/phoenix
