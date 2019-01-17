# implement a function that takes an arbitrary arithmetic expression and returns a natural language version
# explain do: 2 + 3 * 4
# => multiply 3 and 4, then add 2

defmodule Splainer do
  defp do_explain(nil, {op, _line, [left, right]}) when is_number(left) and is_number(right),
    do: do_translate(op, left, right)

  defp do_explain(explanation, {op, _line, [left, right]}) when is_number(left) and is_number(right),
    do: explanation <> ", then " <> do_translate(op, left, right)

  defp do_explain(explanation, {op, _line, [left, right]}) when is_tuple(left) and is_number(right),
    do: do_explain(explanation, left) <> do_translate(op, right)

  defp do_explain(explanation, {op, _line, [left, right]}) when is_number(left) and is_tuple(right),
    do: do_explain(explanation, right) <> do_translate(op, left)

  defp do_explain(explanation, {op, _line, [left, right]}) when is_tuple(left) and is_tuple(right),
    do: do_explain(do_explain(explanation, left), right) <> do_translate(op)

  # seems cleaner to explicitly translate and bind to the operators, than to have a keyword list assigned to formatters
  # ie,
  # @operator_two_params %{+: "add ~s to ~s", ...
  # :io.format operator_two_params[:+], left, right

  defp do_translate(:+, left, right), do: "add #{left} to #{right}"
  defp do_translate(:-, left, right), do: "subtract #{right} from #{left}"
  defp do_translate(:*, left, right), do: "multiply #{left} by #{right}"
  defp do_translate(:/, left, right), do: "divide #{left} by #{right}"
  # defp do_translate(:^, left, right), do: "raise #{left} to the #{nth_power(right)} power"
  # this binary operator doesn't actually exist, could use :math.pow(x,y), but that complicates things.

  defp do_translate(:+, x), do: ", then add #{x}"
  defp do_translate(:-, x), do: ", then subtract #{x}"
  defp do_translate(:*, x), do: ", then multiply by #{x}"
  defp do_translate(:/, x), do: ", then divide by #{x}"
  # defp do_translate(:^, x), do: ", then raise to the #{nth_power(x)} power"

  defp do_translate(:+), do: ", then add the two results"
  defp do_translate(:-), do: ", then subtract the second from the first result"
  defp do_translate(:*), do: ", then multiply the two results"
  defp do_translate(:/), do: ", then divide the first result by the second result"
  # defp do_translate(:^), do: ", then raise the first result to the power of the second"

  # defp nth_power(n) do
  #   case abs(n) do
  #     1 -> "#{n}st"
  #     2 -> "#{n}nd"
  #     3 -> "#{n}rd"
  #     _ -> "#{n}th"
  #   end
  # end

  defmacro splain([do: expression]) do
    {result, _} = Code.eval_quoted(expression)
    do_explain(nil, expression) <> "; which gives you #{inspect result}"
  end
end
