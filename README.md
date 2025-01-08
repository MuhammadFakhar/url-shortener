
# URL Shortener API

A simple URL shortening service, similar to bit.ly, that allows you to shorten long URLs, track the number of visits, and provide analytics.

## Features

- **Shorten a URL**: Converts a long URL into a shorter, manageable URL.
- **Redirect to Original URL**: Redirects the user to the original URL when they visit the shortened URL.
- **Track Analytics**: Tracks visits to the shortened URLs, including information about the device, browser, IP address, and more.
- **URL Expiration**: Allows setting an expiration time for the shortened URL.

## Requirements

- Ruby 3.0 or higher
- Rails 7.x
- PostgreSQL (or other preferred database)
- RSpec for testing
- Ahoy gem for analytics tracking

## Setup Instructions

### 1. Clone the repository

Clone the repository to your local machine:

```bash
git clone https://github.com/MuhammadFakhar/url-shortener.git
cd url-shortener
```

### 2. Install Dependencies

Install the required gems:

```bash
bundle install
```

### 3. Setup the Database

Create and migrate the database:

```bash
rails db:create
rails db:migrate
```

### 4. Running the Application

Start the Rails server:

```bash
rails server
```

You can now access the application the site at `http://localhost:3000`.

## API Endpoints

Here are the available API endpoints for the application:

- **POST /api/urls** - Create a shortened URL
  - Request body:
    ```json
    {
      "long_url": "https://www.sample.com"
    }
    ```
  - Response:
    ```json
    {
      "short_url": "url-shortner-sample123",
      "long_url": "https://www.sample.com"
    }
    ```

- **GET /api/urls** - List all shortened URLs
  - Response:
    ```json
    [
      {
        "short_url": "url-shortner-sample123",
        "long_url": "https://www.sample.com",
        "clicks": 10
      }
    ]
    ```

- **GET /api/urls/:id** - Get details of a shortened URL by `short_url`
  - Response:
    ```json
    {
      "short_url": "url-shortner-sample123",
      "long_url": "https://www.sample.com",
      "clicks": 10
    }
    ```

- **GET /:short_url** - Redirect to the original long URL from a shortened URL

- **GET /api/analytics?long_url=:long_url** - Get analytics for the URL (total visits, browser stats, etc.)
  - Response:
    ```json
    {
      "total_visits": 5,
      "browsers": {
        "Chrome": 5
      },
      "devices": {
        "Desktop": 5
      },
      "user_agents": {
        "Mozilla/5.0...": 5
      },
      "locations": {
        "US": 5
      }
    }
    ```

## Testing

### 1. Running Tests

The project uses **RSpec** for testing. To run all tests, execute the following command:

```bash
bundle exec rspec
```

This will run all the tests and output the results in your terminal.



## Troubleshooting

### 1. Authentication Issues

If you encounter `401 Unauthorized` errors, ensure that you are passing the correct **Authorization headers** in your requests, especially when using **Basic Auth** or **Token Auth**.

for basis authentication, I have set username: `admin` and password `password`

In Order to make request  here is the sample format

```bash
 curl -u admin:password http://localhost:3000/api/urls

or
  http://admin:password@localhost:3000/api/urls
```

### 2. Invalid URL Format

If the `long_url` is invalid, make sure it matches the required format for URLs (e.g., `http` or `https`).


---

## Conclusion

This project provides a URL shortening API with analytics capabilities. The instructions above outline how to set up the application, write tests, and run them successfully. The project also includes robust test coverage to ensure that the URL shortening service works as expected and tracks analytics data.

If you encounter any issues or need additional features, feel free to contribute or reach out!
