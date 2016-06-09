defmodule FunFunAnkiDeck do
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
end
