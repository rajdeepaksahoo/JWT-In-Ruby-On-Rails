# JWT Authentication API – Ruby on Rails

A REST API built using Ruby on Rails that implements user registration and authentication using JSON Web Tokens (JWT).

The application uses BCrypt password hashing and JWT-based authentication to secure API endpoints.

## Features

- User registration
- Password hashing using BCrypt
- User login and credential verification
- JWT token generation using HS256
- JWT token decoding and verification
- Protected API endpoints using an authentication concern
- Proper HTTP response status codes for success and failure scenarios

## Tech Stack

- **Backend:** Ruby on Rails
- **Database:** Active Record
- **Authentication:** JWT
- **Password Security:** BCrypt
- **API Format:** JSON

## Project Structure

```text
app/
├── controllers/
│   ├── concerns/
│   │   └── authenticatable.rb
│   ├── application_controller.rb
│   ├── sessions_controller.rb
│   └── user_controller.rb
│
├── models/
│   └── user.rb
│
└── service/
    └── json_web_token.rb
```

## Setup Instructions

### 1. Clone the repository

```bash
git clone <YOUR_REPOSITORY_URL>
cd jwt
```

### 2. Install dependencies

```bash
bundle install
```

### 3. Configure the database

```bash
rails db:create
rails db:migrate
```

### 4. Start the Rails server

```bash
rails server
```

The application will be available at:

```text
http://localhost:3000
```

## API Endpoints

### 1. Register a User

Creates a new user account.

| Property | Value |
|---|---|
| Method | POST |
| Endpoint | `/sessions` |
| Content-Type | application/json |

**Request Body**

```json
{
  "username": "rajdeepak",
  "password": "password123"
}
```

**Successful Response – 201 Created**

```json
{
  "message": "User created",
  "user": {
    "id": 1,
    "username": "rajdeepak"
  }
}
```

Passwords are hashed using BCrypt before being stored in the database.

### 2. Generate JWT Token

Authenticates the user and generates a JWT token.

| Property | Value |
|---|---|
| Method | POST |
| Endpoint | `/sessions/get_token` |
| Content-Type | application/json |

**Request Body**

```json
{
  "username": "rajdeepak",
  "password": "password123"
}
```

**Successful Response – 200 OK**

```json
{
  "token": "<JWT_TOKEN>"
}
```

**Invalid Credentials – 401 Unauthorized**

```json
{
  "error": "Invalid username or password"
}
```

### 3. Access a Protected Endpoint

Protected endpoints require a valid JWT token.

| Property | Value |
|---|---|
| Method | GET |
| Endpoint | `/user` |
| Header | Authorization: Bearer `<JWT_TOKEN>` |

**Example Header**

```text
Authorization: Bearer <JWT_TOKEN>
```

**Successful Response – 200 OK**

```json
{
  "message": "Welcome to Shop"
}
```

## Authentication Workflow

```text
         User Registration
                |
                v
       Password Hashing
             BCrypt
                |
                v
       Store User in DB
                |
                v
          User Login
                |
                v
      Verify Credentials
         authenticate()
                |
                v
       Generate JWT Token
             HS256
                |
                v
        Client Receives JWT
                |
                v
     Send Token in Authorization
                |
                v
       Decode and Verify JWT
                |
                v
       Identify Authenticated User
                |
                v
       Access Protected API
```

## JWT Implementation

JWT generation and decoding are handled by the `JsonWebToken` service.

### Token Generation

The user ID is stored as a claim in the JWT payload.

```ruby
def self.encode(payload)
  JWT.encode(payload, SECRET_KEY, 'HS256')
end
```

### Token Decoding

The token is decoded and verified using the same secret key and algorithm.

```ruby
def self.decode(token)
  JWT.decode(
    token,
    SECRET_KEY,
    true,
    algorithm: 'HS256'
  ).first
end
```

The decoded payload contains the claims, such as:

```json
{
  "user_id": 1
}
```

### Authentication Concern

The `Authenticatable` concern provides a reusable authentication callback for protected controllers.

It performs the following operations:

1. Extracts the JWT from the Authorization header.
2. Decodes and verifies the token.
3. Retrieves the user using the `user_id` claim.
4. Sets the authenticated user as `@current_user`.
5. Returns an unauthorized response if authentication fails.

## Security Considerations

- Never store plain-text passwords in the database.
- Use BCrypt through Rails `has_secure_password`.
- Never expose the JWT secret key in source control.
- Use environment variables or Rails credentials to manage secrets.
- Set token expiration (`exp`) to limit token validity.
- Use HTTPS in production.
- Never accept `password_digest` directly from client requests.

## Future Improvements

- JWT expiration and refresh-token mechanism
- Role-based authorization
- Logout and token revocation strategy
- Request validation and improved error handling
- Automated tests using RSpec or Minitest

## License

This project is intended for learning and experimentation with JWT authentication in Ruby on Rails.
