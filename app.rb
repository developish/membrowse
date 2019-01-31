require "sinatra"
require "dalli"

configure do
  set :method_override, true
end

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
  @key = params['splat'][0]
  @data = client.fetch(@key)
  erb :show
end

delete "/*" do
  @key = params['splat'][0]
  client.delete(@key)
  redirect "/"
end
