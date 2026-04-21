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

  def get_topic_by_id(conn, %{"id" => topic_id}) do
    case Repo.get(Topic, topic_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(:not_found, id: topic_id)

      topic ->
        conn
        |> put_status(:ok)
        |> render(:show, topic: topic)
    end
  end

  def update(conn, %{"id" => topic_id} = params) do
    topic_params = Map.get(params, "topic", Map.drop(params, ["id"]))

    case Repo.get(Topic, topic_id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(:not_found, id: topic_id)

      topic ->
        changeset = Topic.changeset(topic, topic_params)

        case Repo.update(changeset) do
          {:ok, updated_topic} ->
            conn
            |> put_status(:ok)
            |> render(:show, topic: updated_topic)

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(:error, changeset: changeset)
        end
    end
  end
end
