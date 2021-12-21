defmodule CoinReturn do
  @moduledoc """
  Return exchange on an amount
  """

  @coins [
    1,
    5,
    10
  ]

  def give_back(amount) do
    give_back(amount, @coins, %{})
  end

  def give_back(amount, coins, extra) do
    left = amount - acc(extra)

    coins =
      coins
      |> Enum.filter(&(&1 <= left))
      |> Enum.sort(:desc)

    # Either the solution cointains atleast one of the highest
    # coin or it doesn't include any
    case coins do
      [] ->
        [extra]

      [n] ->
        [Map.update(extra, n, left, &(&1 + left))]

      [high | _] ->
        coins_l = coins |> List.delete(high)
        coins_r = coins
        extra_l = extra
        extra_r = Map.update(extra, high, 1, &(&1 + 1))

        give_back(amount, coins_l, extra_l) ++ give_back(amount, coins_r, extra_r)
    end
  end

  def brute_force(amount) when amount < 100 do
    for x <- 0..100,
        y <- 0..20,
        z <- 0..10 do
      given_back = %{1 => x, 5 => y, 10 => z} |> Map.filter(fn {_, n} -> n > 0 end)

      if acc(given_back) == amount do
        [given_back]
      else
        []
      end
    end
    |> List.flatten()
    |> Enum.reverse()
  end

  def do_brute_force(amount, _coins) do
    {:error, "unable to brute force large amounts #{amount}"}
  end

  def acc(extra) do
    extra
    |> Enum.reduce(0, fn {value, count}, acc -> acc + value * count end)
  end
end
