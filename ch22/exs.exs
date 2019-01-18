# 1. "content" is representation of code, unquote effectively evaluates it and result
#    is bound to the value of the evaluated 'injected' code.  
#
# 2. h IO.ANSI.format/2
#    It converts the given named sequence atoms to actual ANSI codes that
#    the terminal understands.
#
# 3. Seems to go into an infinite loop and soaks up all my memory when the method 
#    that satisfies the guard clause is invoked.
#
#    Dumping the contents of the overridden "def":
#
#Defining a thing
#name    :when
#line    [line: 43]
#args    [{:puts_sum_one, 
#          [line: 43], 
#          [{:a, [line: 43], nil}]
#         },
#         {:is_float, [line: 43], [{:a, [line: 43], nil}]}
#        ]
#content  {{:., [line: 43], [{:__aliases__, [counter: 0, line: 43], [:IO]}, :inspect]}, [line: 43], [{:round, [line: 43], [{:a, [line: 43], nil}]}]}
#Defining a thing
#name    :puts_sum_one
#line    [line: 44]
#args    [{:a, [line: 44], nil}]
#content {{:., [line: 44], [{:__aliases__, [counter: 0, line: 44], [:IO]}, :inspect]}, [line: 44], [{:a, [line: 44], nil}]}
#
#   Looks like the guard clause is broken into its own definition that then has the gaurded definition in the args.
#   Matching for the when with another defmaco fixes the infinite loop.

