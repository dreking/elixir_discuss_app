defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Repo
  alias DiscussWeb.Topic

  def create(conn, params) do
    topic_params = Map.get(params, "topic", params)
    changeset = Topic.changeset(%Topic{}, topic_params)

    case Repo.insert(changeset) do
      {:ok, topic} ->
        conn
        |> put_status(:created)
        |> render(:show, topic: topic)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:error, changeset: changeset)
    end
  end

  def get_all_topics(conn, _params) do
    topics = Repo.all(Topic)

    conn
    |> put_status(:ok)
    |> render(:shows, topics: topics)
  end
end
