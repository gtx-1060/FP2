-module(problem21_test).

-include_lib("eunit/include/eunit.hrl").

test_fun(Solution) ->
    Correct = 31626,
    Res = Solution(),
    ?assert(Correct == Res).

problem21_test() ->
    test_fun(fun problem21:solve/0),
    test_fun(fun problem21:solve_map/0).
