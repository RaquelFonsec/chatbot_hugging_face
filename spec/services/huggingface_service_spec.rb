require 'rails_helper'
require 'webmock/rspec'


RSpec.describe HuggingfaceService do
  let(:prompt) { "Qual é a capital da França?" }
  let(:service) { described_class.new(prompt) }

  describe "#chat" do
    context "quando a API retorna 200 com texto válido" do
      it "retorna o texto gerado" do
        response_body = [{ "generated_text" => "Paris é a capital da França." }].to_json
        stub_request(:post, HuggingfaceService::API_URL)
          .to_return(status: 200, body: response_body, headers: { 'Content-Type' => 'application/json' })

        expect(service.chat).to include("Paris")
      end
    end

    context "quando a API retorna 401 (credencial inválida)" do
      it "retorna mensagem de erro apropriada" do
        stub_request(:post, HuggingfaceService::API_URL)
          .to_return(status: 401, body: "", headers: {})

        expect(service.chat).to include("Credenciais inválidas")
      end
    end

    context "quando a API retorna 503 (indisponível)" do
      it "retorna mensagem de erro 503" do
        stub_request(:post, HuggingfaceService::API_URL)
          .to_return(status: 503, body: "", headers: { 'Content-Type' => 'text/html' })

        expect(service.chat).to include("temporariamente indisponível")
      end
    end

    context "quando a API retorna 402 (limite excedido)" do
      it "retorna mensagem de erro sobre limite" do
        stub_request(:post, HuggingfaceService::API_URL)
          .to_return(status: 402, body: "", headers: {})

        expect(service.chat).to include("Limite de créditos excedido")
      end
    end

    context "quando o JSON de resposta está malformado" do
      it "retorna erro de parser" do
        stub_request(:post, HuggingfaceService::API_URL)
          .to_return(status: 200, body: "INVALID JSON", headers: { 'Content-Type' => 'application/json' })

        expect(service.chat).to include("Erro ao processar a resposta")
      end
    end
  end
end
