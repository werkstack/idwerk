defmodule IdWerk.Authorizations do
  @moduledoc """
  The Authorizations context.
  """

  import Ecto.Query, warn: false
  alias IdWerk.Repo

  alias IdWerk.Authorizations.Resource

  @doc """
  Returns the list of resources.

  ## Examples

      iex> list_resources()
      [%Resource{}, ...]

  """
  def list_resources do
    Repo.all(Resource)
  end

  @doc """
  Gets a single resource.

  Raises `Ecto.NoResultsError` if the Resource does not exist.

  ## Examples

      iex> get_resource!(123)
      %Resource{}

      iex> get_resource!(456)
      ** (Ecto.NoResultsError)

  """
  def get_resource!(id), do: Repo.get!(Resource, id)

  @doc """
  Creates a resource.

  ## Examples

      iex> create_resource(%{field: value})
      {:ok, %Resource{}}

      iex> create_resource(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_resource(%{user: user} = attrs) do
    attrs
    |> Map.put(:group, user.group)
    |> Map.delete(:user)
    |> create_resource()
  end

  def create_resource(%{} = attrs) do
    %Resource{}
    |> Resource.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a resource.

  ## Examples

      iex> update_resource(resource, %{field: new_value})
      {:ok, %Resource{}}

      iex> update_resource(resource, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_resource(%Resource{} = resource, attrs) do
    resource
    |> Resource.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Resource.

  ## Examples

      iex> delete_resource(resource)
      {:ok, %Resource{}}

      iex> delete_resource(resource)
      {:error, %Ecto.Changeset{}}

  """
  def delete_resource(%Resource{} = resource) do
    Repo.delete(resource)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking resource changes.

  ## Examples

      iex> change_resource(resource)
      %Ecto.Changeset{source: %Resource{}}

  """
  def change_resource(%Resource{} = resource) do
    Resource.changeset(resource, %{})
  end

  def parse_docker_scope(scope_str) do
    with [name, identifier, actions] <- String.split(scope_str, ":") do
      {:ok, %{name: name, identifier: identifier, actions: String.split(actions, ",")}}
    else
      _ -> :error
    end
  end

  def access_list(user, service, request_scope) do
    group = user.group
    scopes = Repo.preload(service, :scopes) |> Map.get(:scopes) |> Enum.map(& &1.id)
    query = Resource

    q =
      from q in query,
        where: q.scope_id in ^scopes,
        where: q.group_id == ^group.id,
        preload: [:scope]

    q
    |> Repo.all()
    |> check_wildcard(request_scope)
    |> Enum.map(&%{name: &1.identifier, actions: &1.actions, type: &1.scope.name})
    |> Enum.filter(&(&1.name == request_scope.identifier))
  end

  defp check_wildcard(user_scopes, request_scope) do
    user_scopes
    |> Enum.filter(&(&1.identifier == "*"))
    |> List.first()
    |> case do
      nil ->
        user_scopes

      wildcard ->
        [
          request_scope
          |> Map.put(:scope, wildcard.scope)
          |> Map.put(:actions, wildcard.actions)
        ]
    end
  end
end
