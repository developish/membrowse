require "sinatra"
require "dalli"

client = Dalli::Client.new('localhost')

get "/" do
  @lines = `memdump --server localhost`.split("\n")
  erb :index
end

post "/flush" do
  client.flush
  redirect "/"
end

get "/*" do
  @data = client.fetch(params['splat'][0])
  erb :show
end
