-module(problem9).

-export([solve/0, solve_module/0, solve_lazy/0]).

solve() ->
    solve(1, 1, 1000, 1000).

% A*A + B*B = C*C
solve(A, B, C, _) when A * A + B * B == C * C ->
    A * B * C;
% C = 1000 - A - B
solve(A, B, C, N) ->
    if
        B < C ->
            solve(A, B + 1, C - 1, N);
        true ->
            if
                A < C ->
                    solve(A + 1, A + 2, N - 2 * A - 3, N);
                true ->
                    0
            end
    end.

%   *** module solution ***

solve_module() ->
    Triplets = make_triplets_list(1000),
    PythagoreanTriplets = lists:filter(fun(X) -> is_pythagorean(X) end, Triplets),
    lists:foldl(fun({A, B, C}, Acc) -> Acc + A * B * C end, 0, PythagoreanTriplets).

is_pythagorean({A, B, C}) -> A * A + B * B == C * C.

make_triplets_list(N) ->
    make_triplets_list({1, 2, N - 3}, N).

make_triplets_list({A, B, C}, N) ->
    if
        B < C ->
            [{A, B, C}] ++ make_triplets_list({A, B + 1, C - 1}, N);
        true ->
            if
                A < C ->
                    [{A, B, C}] ++ make_triplets_list({A + 1, A + 2, N - 2 * A - 3}, N);
                true ->
                    []
            end
    end.

%   *** lazy solution ***

solve_lazy() ->
    Iter = iterator_create(),
    Result = find_pythogorian(Iter),
    iterator_close(Iter),
    Result.

find_pythogorian(Iter) ->
    case iterator_next(Iter) of
        {A, B, C} ->
            if
                A * A + B * B == C * C ->
                    A * B * C;
                true ->
                    find_pythogorian(Iter)
            end;
        {} ->
            0
    end.

iterator_create() ->
    spawn(fun() -> iterator({1, 1, 1000}, 1000) end).

iterator_close(Iter) ->
    case is_process_alive(Iter) of
        true ->
            Iter ! {close, self()};
        false ->
            {}
    end.

iterator_next(Iter) ->
    Iter ! {next, self()},
    receive
        Triplet ->
            Triplet
    end.

iterator({A, B, C}, N) ->
    receive
        {next, From} ->
            Triplet = next_triplet(A, B, C, N),
            From ! Triplet,
            iterator(Triplet, N);
        {close, _} ->
            {}
    end.

next_triplet(A, B, C, N) ->
    if
        B < C ->
            {A, B + 1, C - 1};
        true ->
            if
                A < C ->
                    {A + 1, A + 2, N - 2 * A - 3};
                true ->
                    {1, 1, N}
            end
    end.
