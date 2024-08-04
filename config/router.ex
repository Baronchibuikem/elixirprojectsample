scope "/", BlogAppWeb do
  pipe_through :api

  get "/blogs", BlogController, :index
  post "/blogs", BlogController, :create
  # ... other routes
end
