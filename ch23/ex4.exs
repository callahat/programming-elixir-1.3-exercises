#defimpl Inspect, for: Any do
#  def inspect(%{__struct__: _} = map, %{structs: false}) do
#    map
#  end
#end

# Not sure about this one. The above gives a error,
# not sure how to bypass inspect (as thats what it seems to need?)
#
# Without the inspect, it returns the struct literal/map though
#
# iex> %Bob{a: 1}
# ===  %Bob{a: 1}
# iex> inspect %Bob{a: 4}
# ===  "%Bob{a: 4}"
# iex> inspect %Bob{a: 4}, structs: false
# ===  "%{__struct__: Bob, a: 4}"
# 
# One could `Code.eval_string inspect %Bob{a: 1}`, and pick off the struct from the first
# part of the tuple
