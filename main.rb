require 'sinatra'
require 'sinatra/reloader' if development?
require 'pg'
require 'pry-byebug'

get '/' do
  redirect to ('/videos')
end

get '/videos/new' do
  erb :new
end

post '/videos' do
  sql = "insert into videos (title, description, url, genre) values ('#{params[:title]}','#{params[:description]}','#{params[:url]}','#{params[:genre]}')"
  run_sql(sql)
  redirect to('/videos')
end

get '/videos' do
  # get the videos from the db, and assign to instance variable
  sql = 'select * from videos'
  @videos = run_sql(sql)
  erb :index
end

get '/videos/:id' do
  sql = "select * from videos where id = #{params[:id]}"
  @videos = run_sql(sql).first
  erb :show
end





private

def run_sql(sql)
  conn = PG.connect(dbname: 'memetube', host: 'localhost')
  begin
    result = conn.exec(sql)
  ensure 
    conn.close
  end
  result
end