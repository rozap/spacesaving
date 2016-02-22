defmodule SpacesavingTest do
  use ExUnit.Case
  doctest Spacesaving

  test "can count some numbers" do
    state = Spacesaving.init(3)

    state = Enum.reduce(1..16, state, fn _, state ->
      state
      |> Spacesaving.push(:foo)
      |> Spacesaving.push(:foo)
      |> Spacesaving.push(:foo)
      |> Spacesaving.push(:bar)
      |> Spacesaving.push(:bar)
      |> Spacesaving.push(:bar)
      |> Spacesaving.push(:baz)
      |> Spacesaving.push(:buzz)

    end)

    # baz and buz thrash back and forth, so the estimate is
    # on the upper bound of the error
    assert state == {%{bar: 48, buzz: 32, foo: 48}, 3}
  end

  test "can get back the top k" do
    state = Spacesaving.init(8)

    state = Enum.reduce(1..16, state, fn _, state ->
      state
      |> Spacesaving.push(:foo)
      |> Spacesaving.push(:foo)
      |> Spacesaving.push(:foo)
      |> Spacesaving.push(:bar)
      |> Spacesaving.push(:bar)
      |> Spacesaving.push(:bar)
      |> Spacesaving.push(:baz)
      |> Spacesaving.push(:buzz)

    end)

    top_k = Spacesaving.top(state, 2)
    |> Enum.sort_by(fn {key, _} -> key end)


    assert top_k == [bar: 48, foo: 48]

    top_k = Spacesaving.top(state, 20)
    |> Enum.sort_by(fn {key, _} -> key end)


    assert top_k == [bar: 48, baz: 16, buzz: 16, foo: 48]

  end

  test "can merge two counters" do
    left  = Spacesaving.init(3)
    right = Spacesaving.init(3)

    left = Enum.reduce(1..16, left, fn _, acc ->
      acc
      |> Spacesaving.push(:foo)
      |> Spacesaving.push(:foo)
      |> Spacesaving.push(:foo)
      |> Spacesaving.push(:bar)
      |> Spacesaving.push(:bar)
      |> Spacesaving.push(:bar)
      |> Spacesaving.push(:baz)
      |> Spacesaving.push(:buzz)
      |> Spacesaving.push(:buzz)
    end)

    right = Enum.reduce(1..16, right, fn _, acc ->
      acc
      |> Spacesaving.push(:foo)
      |> Spacesaving.push(:foo)
      |> Spacesaving.push(:foo)
      |> Spacesaving.push(:bar)
      |> Spacesaving.push(:biz)
    end)

    merged = Spacesaving.merge(left, right)
    assert merged == {%{foo: 96, bar: 64, buzz: 48}, 3}
  end


end
