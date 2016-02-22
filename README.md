# Spacesaving

Simple algorithm to estimate count distinct elements in a stream using bounded space. The estimate is the upper bound on the element.

## Usage

```elixir
import Spacesaving

# Init with 3 spaces, so we track 3 elements
state = init(3)
```

Push some elements
```elixir
state = state
|> push(:foo) |> push(:foo) |> push(:foo) |> push(:foo)
|> push(:bar) |> push(:bar) |> push(:bar)
|> push(:baz) |> push(:baz)
|> push(:buzz)
```

Get the top k elements
```elixir
top(state, 2) # This will be [foo: 4, bar: 3]
top(state, 3) # This will be [foo: 4, bar: 3, buzz: 3], so the inaccuracy starts to come into play when an element is kicked out, and the estimate is the upper bound
```

Merge two states
```elixir
left  = init(4) |> push(:foo) |> push(:bar)
right = init(4) |> push(:foo) |> push(:baz)

merge(left, right)
|> top(3) # Would be [foo: 2, bar: 1, baz: 1]
```

## References
[Original Paper](https://icmi.cs.ucsb.edu/research/tech_reports/reports/2005-23.pdf)