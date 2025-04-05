class MessagesController < ApplicationController
  def index
    @messages = Message.order(created_at: :asc)
  end

  def create
    user_message = Message.create!(role: "user", content: params[:content])

    begin
      resposta = HuggingfaceService.new(params[:content]).chat
    rescue => e
      
      flash[:error] = "Falha inesperada — #{e.message}"


      redirect_to root_path and return
    end

    Message.create!(role: "assistant", content: resposta)
    redirect_to root_path
  end
end
