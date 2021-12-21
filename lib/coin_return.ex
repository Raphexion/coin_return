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

    # This is a very important step that is easy to overlook.
    # We prune coins, which means that we keep our solution
    # from going into an endless loop. The reason is that
    # when we take the right branch below, we don't actually
    # prune the coin types, which would make the algorithm
    # continue forever. But we have a extra pruning step here
    # that prevents the tree to grow forever.
    # Moreover, we make sure that we are always have the coins
    # sorted in descending order. So we always look at the highest
    # coin type when we split into the left and right branch.
    coins =
      coins
      |> Enum.filter(&(&1 <= left))
      |> Enum.sort(:desc)

    case coins do
      [] when left == 0 ->
        # No coins are left to use and nothing left to distribute.
        [extra]

      [1] ->
        # Only the one-coin is left to distribute
        [Map.update(extra, 1, left, &(&1 + left))]

      [high | _] ->
        # Key part of the algorithm:
        #  Either the solution cointains atleast one of the highest
        #  coin or it doesn't include any off them.

        # Left branch: Does not contain any of the hightest coins
        coins_l = coins |> List.delete(high)
        extra_l = extra

        # Right branch: Contains atleast one of the highest coins
        coins_r = coins
        extra_r = Map.update(extra, high, 1, &(&1 + 1))

        # Merge solutions for the left and right branch
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
  end

  def brute_force(amount, _coins) do
    {:error, "unable to brute force large amounts #{amount}"}
  end

  def acc(extra) do
    extra
    |> Enum.reduce(0, fn {value, count}, acc -> acc + value * count end)
  end
end
