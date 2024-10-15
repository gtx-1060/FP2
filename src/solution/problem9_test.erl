-module(problem9_test).

-include_lib("eunit/include/eunit.hrl").

test_fun(Solution) ->
    Correct = 31875000,
    Res = Solution(),
    ?assert(Correct == Res).

problem21_test() ->
    test_fun(fun problem9:solve/0),
    test_fun(fun problem9:solve_module/0),
    test_fun(fun problem9:solve_lazy/0).
