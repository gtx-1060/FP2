-module(problem21).

-export([solve/0, solve_map/0]).

solve() -> solve(1, 10_000).

solve(X, N) when X >= N ->
    0;
solve(X, N) ->
    Sum1 = sum_proper_divisors(X),
    Sum2 = sum_proper_divisors(Sum1),
    if
        X == Sum2, X /= Sum1 ->
            PartSum = solve(X + 1, N),
            PartSum + X;
        true ->
            solve(X + 1, N)
    end.

sum_proper_divisors(N) ->
    sum_proper_divisors(N, 2) + 1.

sum_proper_divisors(N, X) when X > N div 2 ->
    0;
sum_proper_divisors(N, X) when N rem X == 0 ->
    X + sum_proper_divisors(N, X + 1);
sum_proper_divisors(N, X) ->
    sum_proper_divisors(N, X + 1).

%   *** module solution with map ***

solve_map() -> solve_map(10_000).

solve_map(N) ->
    AmicablePairs = gen_amicable_pairs(1, N),
    lists:foldl(fun({A, _}, Sum) -> Sum + A end, 0, AmicablePairs).

gen_amicable_pairs(Start, Stop) ->
    Seq = lists:seq(Start, Stop),
    lists:filtermap(fun(X) -> gen_amicable_pair(X) end, Seq).

gen_amicable_pair(X) ->
    Sum1 = lists:sum(proper_divisors(X)),
    Sum2 = lists:sum(proper_divisors(Sum1)),
    if
        X == Sum2, X /= Sum1 ->
            {true, {X, Sum1}};
        true ->
            false
    end.

proper_divisors(X) ->
    lists:filter(
        fun(I) ->
            X rem I == 0
        end,
        lists:seq(1, X div 2)
    ).
