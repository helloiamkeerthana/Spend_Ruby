require 'net/http'
require 'json'

class OpenAIService
  API_KEY = ENV['OPENAI_API_KEY']
  ENDPOINT = 'https://api.openai.com/v1/completions'

  def self.categorize_complaint(content)
    response = post_to_openai(content)
    categories = parse_response(response)
    { category: categories[:category], sub_category: categories[:sub_category] }
  end

  private

  def self.post_to_openai(content)
    uri = URI(ENDPOINT)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json', 'Authorization' => "Bearer #{API_KEY}")
    request.body = {
      model: 'text-davinci-003',
      prompt: "Categorize the following complaint: #{content}",
      max_tokens: 100
    }.to_json

    response = http.request(request)
    JSON.parse(response.body)
  end

  def self.parse_response(response)
    text = response['choices'][0]['text']
    lines = text.split("\n").map(&:strip)
    category = lines[0].split(":")[1].strip
    sub_category = lines[1].split(":")[1].strip
    { category: category, sub_category: sub_category }
  end
end
