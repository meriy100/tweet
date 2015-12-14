require "twitter"
require "tempfile"
require "yaml"


def tweet message, option = {}
  config = YAML.load_file "./config.yml"
  client = Twitter::REST::Client.new do |client_config|
    client_config.consumer_key        = config["twitter_api"]["consumer_key"]
    client_config.consumer_secret     = config["twitter_api"]["consumer_secret"]
    client_config.access_token        = config["twitter_api"]["access_token"]
    client_config.access_token_secret = config["twitter_api"]["access_token_secret"]
  end
  if message
    client.update! message
    puts "succese tweet! #{message}"
  else
    tmp = Tempfile.new "message"
    system "#{config["editer"]} #{tmp.path}"
    message = tmp.open.read
    tmp.delete
    if message.length > 0
      client.update! message
      puts "succese tweet! #{message}"
    end
  end

rescue Twitter::Error::DuplicateStatus => e
  puts e
end

tweet ARGV.first



