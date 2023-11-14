# Lunch and Learn API

This api allows a user to register, login, search for cusines by country, learn more about that country, favorite recipes, and get their favorited recipes.

## Table of Contents:
1. [Learning Goals](#learning-goals)
2. [Setup](#setup)
   - [Edamam Setup](#edamam-setup)
   - [Youtube (Google) Setup](#youtube-google-api-setup)
   - [Unslpash Setup](#unsplash)
   - [REST Countries API Setup](#rest-countries)
3. [Endpoints](#endpoints)
   - [Get Recipes for a Particular Country](#get-recipes-for-a-particular-country)
   - [Get Learning Resources for a Particular Country](#get-learning-resources-for-a-particular-country)
   - [User Registration](#user-registration)
   - [Log In User](#log-in-user)
   - [Add Favorites](#add-favorites)
   - [Get a User's Favorites](#get-a-users-favorites)

## Learning Goals

- Create API endpoint that gets data from other APIs
- Create API endpoint that require an api key to function
- Implement basic user authentication
- Create API endpoints for CRUD functionality
- Implement API endpoints designed for functionality of other developers
- Implement thorough testing of both consumption of external APIs and endpoints using testing tools

## Setup

This api calls on 4 other external APIs. These are:
- edamam
- youtube (google)
- unsplash
- REST Countries API

### Edamam Setup

In order to be able to call the edamam API you will need an application id and an API key. You can visit [this](https://developer.edamam.com/edamam-recipe-api) site in order to sign up and create an application to receieve your application id and API key. You will then need to set up your rails credentials with both.

### Youtube (Google API) setup

In order to be able to call the Youtube search list API you will need an API key. You can visit [this](https://developers.google.com/youtube/v3/getting-started) site in order ot learn how to obtain an API key for the Youtube Data API. You will then need to set up your rails credentials with the key.

### Unsplash

In order to be able to call the Unsplash API you will need an API key. You can visit [this](https://unsplash.com/developers) site to sign up as a developer and get an API key. You will then need to set up your rails credentials with the key.

### REST Countries

This API does not require any authorization credentials and should work out of the box.

# Endpoints

### Get Recipes For a Particular Country

Request:
```
GET /api/v1/recipes?country=country_here
```
   - The parameters being passed through are a country, which will replace `country_here` in the request

Regular Response:

```
{
  "data": [
    {
      "id": null,
      "type": "recipe",
      "attributes": {
        "title": "Andy Ricker's Naam Cheuam Naam Taan Piip (Palm Sugar Simple Syrup)",
        "url": "https://www.seriouseats.com/recipes/2013/11/andy-rickers-naam-cheuam-naam-taan-piip-palm-sugar-simple-syrup.html",
        "country": "thailand",
        "image": "https://edamam-product-images.s3.amazonaws.com/web-img/611/..."
      }
    }
  ]
}
```

Response if No Recipes or Country is Empty String
```
{
  "data": []
}
```

### Get Learning Resources for a Particular Country
Request:
```
GET /api/v1/learning_resources?country=country_here
```
   - The parameters being passed through are a country, which will replace `country_here` in the request

Regular Response:
```
  {
    "data": {
      "id": null,
      "type": "learning_resource",
      "attributes": {
        "country": "laos",
        "video": {
          "title": "A Super Quick History of Laos",
          "youtube_video_id": "uw8hjVqxMXw
        },
        "images": [
          {
            "alt_tag": "The picture taken in Laos, 06:00, from hot baloon",
            "url": "https://images.unsplash.com/photo-1540611025311-01df3cef54b5?ixid=M3w1MjczNzZ8MHwxfHNlYXJjaHwxfHxsYW9zfGVufDB8fHx8MTY5OTg0NzUwN3ww&ixlib=rb-4.0.3"
          },
          {...},
          {...}
        ]
      }
    }
  }
```

Response if there are no videos or images:
```
  {
    "data": {
      "id": null,
      "type": "learning_resource",
      "attributes": {
        "country": "country_name",
        "video": {},
        "images": []
      }
    }
  }
```

### User Registration
Request:
```
POST /api/v1/users

body (json):
{
  "name": "Susy",
  "email": "susy@email.com",
  "password": "1234",
  "password_confirmation": "1234"
}
```
   - The user registration information must be sent to this endpoint with a body of parameters and not query paramaters in the URI.

Regular Response:
```
  {
    "data": {
      "type": "user",
      "id": "1",
      "attributes": {
        "name": "Susy",
        "email": "susy@email.com",
        "api_key": "hdl129745hdkalckd9274"
      }
    }
  }
```

Response if password confirmation doesn't match:
```
  {
    "errors": [
      {
        "status": "400",
        "title": "Your password confirmation is not correct, please try again."
      }
    ]
  }
```

Response if email is not unique:
```
  {
    "errors": [
      "status": "400",
      "title": "Validation failed: Email has already been taken"
    ]
  }
```

### Log In User
Request:
```
POST /api/v1/sessions

body (json):
{
  "email": "susy@email.com",
  "password": "1234"
}
```
   - The user login information must be sent to this endpoint with a body of parameters and not query paramaters in the URI.

Regular Response
```
  {
    "data": {
      "type": "user",
      "id": "1",
      "attributes": {
        "name": "Susy",
        "email": "susy@email.com",
        "api_key": "hdl129745hdkalckd9274"
      }
    }
  }
```

Response if login unsuccessful:
```
  {
    "errors": [
      {
        "status": "400",
        "title": "Your credentials are incorrect, please try again."
      }
    ]
  }
```

### Add Favorites 
Request:
```
POST /api/v1/favorites

body (json):
{
  "api_key": "hdl129745hdkalckd9274",
  "country": "thailand",
  "recipe_link": "https://www.seriouseats.com/recipes/2013/11/andy-rickers-naam-cheuam-naam-taan-piip-palm-sugar-simple-syrup.html",
  "recipe_title": "Andy Ricker's Naam Cheuam Naam Taan Piip (Palm Sugar Simple Syrup)"
}
```
   - The favorite recipe information must be sent to this endpoint with a body of parameters and not query paramaters in the URI.

Regular Response:
```
  {
    "success": "Favorite added successfully"
  }
```

Response if API key is invalid:
```
  {
    "errors": [
      {
        "status": "400",
        "title": "Api key invalid"
      }
    ]
  }
```

Response if favorite is not created:
```
  {
    "errors": [
      {
        "status": "400",
        "title": "Validation failed: Recipe link can't be blank, Recipe title can't be blank
      }
    ]
  }
```
   - The title of this error will differ depending on what aspect of the favorite that was required was not present.

### Get a User's Favorites
Request:
```
GET /api/v1/favorites?api_key=hdl129745hdkalckd9274
```

Regular Response:
```
  {
    "data": [
      {
        "id": "1",
        "type": "favorite",
        "attributes": {
          "recipe_title": "recipe 1",
          "recipe_link": "https://recipe_link_1.com",
          "country": "country 1",
          "created_at": "2023-11-13T21:31:50.714Z"
        },
        {...},
        {...}
      }
    ]
  }
```

Response if API Key is Invalid:
```
  {
    "errors": [
      {
        "status": "400",
        "title": "Api key invalid"
      }
    ]
  }
```

Response if User has no Favorites:
```
  {
    "data": []
  }
```