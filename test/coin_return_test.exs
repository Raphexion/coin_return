defmodule CoinReturnTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  describe "return coins on" do
    test "1" do
      expected = [%{1 => 1}]

      assert CoinReturn.give_back(1) == expected
    end

    test "5" do
      expected = [
        %{
          1 => 5
        },
        %{
          5 => 1
        }
      ]

      assert CoinReturn.give_back(5) == expected
    end

    test "7" do
      expected = [
        %{
          1 => 7
        },
        %{
          1 => 2,
          5 => 1
        }
      ]

      assert CoinReturn.give_back(7) == expected
    end

    test "11" do
      expected = [
        %{
          1 => 11
        },
        %{
          1 => 6,
          5 => 1
        },
        %{
          1 => 1,
          5 => 2
        },
        %{
          1 => 1,
          10 => 1
        }
      ]

      assert CoinReturn.give_back(11) == expected
    end

    test "15" do
      expected = [
        %{
          1 => 15
        },
        %{
          1 => 10,
          5 => 1
        },
        %{
          1 => 5,
          5 => 2
        },
        %{
          5 => 3
        },
        %{
          1 => 5,
          10 => 1
        },
        %{
          5 => 1,
          10 => 1
        }
      ]

      assert CoinReturn.give_back(15) == expected
    end
  end

  describe "helpers" do
    test "acc" do
      assert CoinReturn.acc(%{1 => 2, 5 => 2, 10 => 2}) == 32
    end
  end

  property "returned coins equals original amount" do
    check all amount <- positive_integer(),
              amount < 1000 do
      amounts =
        amount
        |> CoinReturn.give_back()
        |> Enum.map(&CoinReturn.acc/1)

      assert Enum.all?(amounts, &(&1 == amount))
    end
  end

  property "same as brute-forced amount" do
    check all amount <- positive_integer(),
              amount < 100 do
      assert sorted(CoinReturn.give_back(amount)) == sorted(CoinReturn.brute_force(amount))
    end
  end

  defp sorted(solution, coins \\ [1, 5, 10, 20, 50, 100]) do
    solution
    |> Enum.sort_by(&solution_tuple(&1, coins))
  end

  defp solution_tuple(given_back, coins) do
    coins
    |> Enum.map(&Map.get(given_back, &1, 0))
    |> List.to_tuple()
  end
end
