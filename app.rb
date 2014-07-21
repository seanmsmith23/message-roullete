require "sinatra"
require "active_record"
require "gschool_database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash

  def initialize
    super
    @database_connection = GschoolDatabaseConnection::DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    messages = @database_connection.sql("SELECT * FROM messages")
    comments = @database_connection.sql("SELECT * FROM comments")

    erb :home, locals: {messages: messages, comments: comments}
  end

  get "/messages/:id" do
    id = params[:id]
    message = @database_connection.sql("SELECT * FROM messages WHERE id = #{id}").pop
    comments = @database_connection.sql("SELECT * FROM comments WHERE message_id = #{id}")

    erb :message, locals: {message: message, comments: comments}
  end

  post "/messages" do
    message = params[:message]
    if message.length <= 140
      @database_connection.sql("INSERT INTO messages (message) VALUES ('#{message}')")
    else
      flash[:error] = "Message must be less than 140 characters."
    end
    redirect "/"
  end

  get "/messages/:id/edit" do
    id = params[:id]
    message_data = @database_connection.sql("SELECT * FROM messages WHERE id = #{id}").pop

    erb :edit_message, locals: { :message => message_data }
  end

  patch "/messages/:id" do
    id = params[:id]
    edited = params[:edit_message]

    if edited.length <= 140
      @database_connection.sql("UPDATE messages SET message = '#{edited}' WHERE id = #{id}")
    else
      flash[:error] = "Message must be less than 140 characters."
      redirect back
    end

    redirect "/"
  end

  delete "/messages/:id" do
    id = params[:id]

    @database_connection.sql("DELETE FROM messages WHERE id = #{id}")

    redirect "/"
  end

  get "/comments/:id/new" do
    id = params[:id]

    erb :add_comment, locals: { :message_id => id }
  end

  post "/comments/:id" do
    id = params[:id]
    comment = params[:comment]

    @database_connection.sql("INSERT INTO comments (comment, message_id) VALUES ('#{comment}', #{id})")

    redirect "/"
  end

end