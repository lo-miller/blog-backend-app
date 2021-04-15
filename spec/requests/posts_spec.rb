require 'rails_helper'

RSpec.describe "Posts", type: :request do
  describe "GET /posts" do
    it "should return all the posts in the db" do
      # make user in test db
      user=User.create!(name: "David Bowie" , email: "david@email.com" , password: "password")
      # make post in test db - user_id, title, body, image
      post=Post.create!(user_id: user.id, title: "Sample Blog Post", body: "blog blog blog", image: "url goes here")
      post=Post.create!(user_id: user.id, title: "Sample Blog Post 2", body: "blog blog blog blog", image: "url goes here")
      # web request
      get "/api/posts"
      # results 
      posts = JSON.parse(response.body)
      
      expect(response).to have_http_status(200)
      expect(posts.length).to eq(2)
    end
  end
  
  describe "POST /posts" do
    it "should create a new post in the db (happy path with valid params)" do
      # make user in test db
      user=User.create!(name: "David Bowie" , email: "david@email.com" , password: "password")
      # JWT creation
      jwt = JWT.encode(
        {
          user: user.id, # the data to encode
          exp: 24.hours.from_now.to_i # the expiration time
        },
        "random", # the secret key
        'HS256' # the encryption algorithm
      )
      # post request with params hard coded (test post)
      post "/api/posts", params: {
        user_id: user.id,
        title: "blog post title",
        body:"blogggggg",
        image: "image URL"
      },
      # JWT authorization
      headers: {"Authorization" => "Bearer #{jwt}"}
      # response and validation
      post = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(post["title"]).to eq("blog post title")

    end
    t "should create a new post in the db (sad path with invalid params)" do
      # make user in test db
      user=User.create!(name: "David Bowie" , email: "david@email.com" , password: "password")
      # JWT creation
      jwt = JWT.encode(
        {
          user: user.id, # the data to encode
          exp: 24.hours.from_now.to_i # the expiration time
        },
        "random", # the secret key
        'HS256' # the encryption algorithm
      )
      # post request with params hard coded (test post)
      post "/api/posts", params: {
        user_id: user.id,
        title: "blog post title",
        body:"blogggggg",
        image: "image URL"
      },
      # JWT authorization
      headers: {"Authorization" => "Bearer #{jwt}"}
      # response and validation
      post = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(post["title"]).to eq("blog post title")

    end
  end
end
