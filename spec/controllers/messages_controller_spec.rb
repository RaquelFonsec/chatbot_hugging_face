require 'rails_helper'
require 'webmock/rspec'

RSpec.describe MessagesController, type: :controller do
  describe "POST #create" do
    let(:user_input) { "Qual a capital do Brasil?" }
    let(:ia_response) { "A capital do Brasil é Brasília." }

    before do
      # Cria stub da resposta da HuggingfaceService
      stub_request(:post, HuggingfaceService::API_URL)
        .to_return(
          status: 200,
          body: [
            { "generated_text" => ia_response }
          ].to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it "cria uma mensagem do usuário e da IA, e redireciona para root_path" do
      expect {
        post :create, params: { content: user_input }
      }.to change(Message, :count).by(2) # uma do user e uma da IA

      expect(response).to redirect_to(root_path)

      last_messages = Message.order(created_at: :asc).last(2)
      expect(last_messages[0].role).to eq("user")
      expect(last_messages[0].content).to eq(user_input)

      expect(last_messages[1].role).to eq("assistant")
      expect(last_messages[1].content).to include("Brasília")
    end

    it "lida com erros e redireciona com flash[:error]" do
      allow_any_instance_of(HuggingfaceService).to receive(:chat).and_raise(StandardError.new("Falha na IA"))

      post :create, params: { content: user_input }

      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to include("Falha inesperada — Falha na IA")

    end
  end
end
