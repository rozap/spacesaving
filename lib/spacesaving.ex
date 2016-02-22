defmodule Spacesaving do

  @doc """
  Initialize the state

  ## Examples

      iex> Spacesaving.init(2)
      {%{}, 2}
  """
  def init(n) do
    {%{}, n}
  end

  @doc """
  Add the item, which should be an atom or string to the state

  ## Examples

      iex> Spacesaving.init(2) |> Spacesaving.push(:foo) |> Spacesaving.push(:bar)
      {%{foo: 1, bar: 1}, 2}
      iex> Spacesaving.init(2) |> Spacesaving.push(:foo) |> Spacesaving.push(:foo) |> Spacesaving.push(:bar) |> Spacesaving.push(:baz)
      {%{foo: 2, baz: 2}, 2}
  """
  def push({counts, max}, item) do
    counts = if Map.has_key?(counts, item) or Enum.count(counts) < max do
      Map.update(counts, item, 1, fn c -> c + 1 end)
    else
      {key, count} = Enum.min_by(counts, fn {_, c} -> c end)

      counts
      |> Map.delete(key)
      |> Map.put(item, count + 1)
    end

    {counts, max}
  end


  @doc """
  Get the top k counts as a descending sorted key list

  ## Examples

      iex> {%{foo: 3, baz: 2}, 2} |> Spacesaving.top(2)
      [foo: 3, baz: 2]
      iex> {%{foo: 3, baz: 2}, 2} |> Spacesaving.top(1)
      [foo: 3]
  """
  def top({counts, _}, k), do: top_counts(counts, k)

  defp top_counts(counts, k) do
    counts
    |> Enum.into([])
    |> Enum.sort_by(fn {_, c} -> -c end)
    |> Enum.take(k)
  end


  @doc """
  Merge two states together, adding the counts for keys in both
  counters. The new state will be the minimum of
  the two states' sizes.

  ## Examples

      iex> Spacesaving.merge({%{foo: 3, baz: 2}, 2}, {%{foo: 3, baz: 2}, 2})
      {%{foo: 6, baz: 4}, 2}

      iex> Spacesaving.merge({%{foo: 3, bar: 1}, 2}, {%{foo: 3, baz: 2}, 2})
      {%{foo: 6, baz: 2}, 2}
  """
  def merge({left, left_max}, {right, right_max}) do
    new_max = min(left_max, right_max)

    merged = Map.merge(left, right, fn _k, v0, v1 -> v0 + v1 end)
    |> top_counts(new_max)
    |> Enum.into(%{})

    {merged, new_max}
  end

end
