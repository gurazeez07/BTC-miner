defmodule PROJECT1Test do
  use ExUnit.Case
  doctest PROJECT1

  test "greets the world" do
    assert PROJECT1.hello() == :world
  end
end
