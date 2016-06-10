defmodule FunFunAnkiDeck do
  def run do
    configure
    tweets = fetch
    |> filter_retweets
    |> parse
    File.write("anki.csv", tweets)
  end

  def configure do
    Dotenv.load!
    ExTwitter.configure(
      consumer_key: System.get_env("TWITTER_KEY"),
      consumer_secret: System.get_env("TWITTER_SECRET"),
      access_token: System.get_env("TWITTER_ACCESS_TOKEN"),
      access_token_secret: System.get_env("TWITTER_TOKEN_SECRET")
    )
  end

  def fetch do
    ExTwitter.user_timeline(screen_name: "funfunconv", count: 1000)
    |> Enum.map(fn(t) -> t.text end)
  end

  def filter_retweets(tweets) do
    tweets
    |> Enum.reject(fn tweet -> String.match?(tweet, ~r/RT/) end)
  end

  def parse(tweets) do
    tweets
    |> Enum.map(fn tweet -> Regex.named_captures(~r/(?<english>(\w*\W\w*)*[\.!?]) (?<japanese>.*)/, tweet) end)
    |> Enum.reject(fn x -> is_nil(x) end)
    |> Enum.reduce("", fn x, acc -> acc <> "\n#{x["english"]}\t#{x["japanese"]}" end)
  end
end
