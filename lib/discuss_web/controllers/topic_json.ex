defmodule DiscussWeb.TopicJSON do
  alias DiscussWeb.Topic

  def show(%{topic: topic}), do: %{data: data(topic)}

  def error(%{changeset: changeset}) do
    %{errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1)}
  end

  defp data(%Topic{} = topic) do
    %{id: topic.id, title: topic.title}
  end

  defp translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end

  def shows(%{topics: topics}), do: %{data: Enum.map(topics, &data/1)}
end
