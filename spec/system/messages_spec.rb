require 'rails_helper'

RSpec.describe "Chat com IA", type: :system do
  before do
    driven_by(:rack_test)

    # Mock da HuggingfaceService
    allow_any_instance_of(HuggingfaceService).to receive(:chat)
      .and_return("A capital da França é Paris.")
  end

  it "envia uma mensagem e mostra a resposta da IA" do
    visit root_path

    fill_in "Digite sua pergunta:", with: "Qual a capital da França?"
    click_button "✉️ Enviar"

    expect(page).to have_content("👤 Você: Qual a capital da França?")
    expect(page).to have_content("🤖 IA: A capital da França é Paris.")
  end

  it "mostra mensagem de erro se Huggingface falha" do
    allow_any_instance_of(HuggingfaceService).to receive(:chat)
      .and_raise(StandardError.new("Falha na IA"))

    visit root_path
    fill_in "Digite sua pergunta:", with: "Erro?"
    click_button "✉️ Enviar"

    expect(page).to have_content("⚠️ Erro: Falha inesperada — Falha na IA")
  end

  it "mantém mensagens em ordem cronológica" do
    Message.create!(role: "user", content: "Pergunta 1")
    Message.create!(role: "assistant", content: "Resposta 1")
    Message.create!(role: "user", content: "Pergunta 2")
    Message.create!(role: "assistant", content: "Resposta 2")

    visit root_path

    expect(page).to have_selector("p", text: "👤 Você: Pergunta 1")
    expect(page).to have_selector("p", text: "🤖 IA: Resposta 1")
    expect(page).to have_selector("p", text: "👤 Você: Pergunta 2")
    expect(page).to have_selector("p", text: "🤖 IA: Resposta 2")
  end
end
