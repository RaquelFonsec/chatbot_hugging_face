class HuggingfaceService
  API_URL = "https://api-inference.huggingface.co/models/mistralai/Mistral-7B-Instruct-v0.1"

  def initialize(user_input)
    @prompt = "<s>[INST] #{user_input.strip} [/INST]"
    @token = ENV['HUGGINGFACE_API_KEY'] || "REMOVIDO"
  end

  def chat
    uri = URI(API_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{@token}"
    request["Content-Type"] = "application/json"
    request.body = { inputs: @prompt }.to_json

    response = http.request(request)

    if response['Content-Type']&.include?("text/html")
      return "Erro: Serviço temporariamente indisponível (503)."
    end

    case response.code.to_i
    when 200
      begin
        json = JSON.parse(response.body)

        if json.is_a?(Array) && json[0]["generated_text"]
          generated = json[0]["generated_text"]
          resposta = generated.sub(@prompt, "").strip
          return resposta.presence || "Resposta vazia recebida."
        else
          return "Resposta não identificada."
        end
      rescue JSON::ParserError => e
        return "Erro ao processar a resposta do servidor: #{e.message}"
      end

    when 401
      "Erro: Credenciais inválidas. Verifique a chave da API Hugging Face."
    when 429
      "Muitas requisições! Aguarde um pouco e tente novamente."
    when 402
      "Erro: Limite de créditos excedido. Tente novamente em breve ou assine um plano PRO para continuar."
    when 503
      "Erro: Serviço temporariamente indisponível (503)."
    else
      "Erro inesperado: #{response.code} - #{response.body}"
    end

  rescue Net::OpenTimeout => e
    "Erro de tempo de conexão: #{e.message}"
  rescue => e
    "Erro inesperado: #{e.class} - #{e.message}"
  end
end
