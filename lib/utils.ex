defmodule WpConfigWriter.Utils do
  defmodule Guards do
    defguard is_valid(input) when input not in [nil, ""]
  end

  def mask(string) when is_binary(string) do
    do_mask(string, "")
  end

  def mask(_), do: :error

  defp do_mask("", _), do: :error

  defp do_mask(<<last::binary-size(1), ""::binary>>, string), do: string <> last

  defp do_mask(<<first::binary-size(1), rest::binary>>, <<""::binary>> = string) do
    do_mask(rest, string <> first)
  end

  defp do_mask(<<_::binary-size(1), rest::binary>>, string) do
    do_mask(rest, string <> "*")
  end
end
