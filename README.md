# Лабораторная работа 1
Ненов Влад, P34082
Вариант: 9, 21
=====
## Problem 9. Special Pythagorean Triplet
Требуется найти произведение такой тройки a, b, c, для которой:
- `a*a + b*b = c*c`
- `a + b + c = 1000`

### Обычное решение (хвостовая рекурсия)
```erlang
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
```

### Модульное решение
```erlang 
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
```

### Решение с итератором
```erlang
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

```

## Problem 21. Amicable Numbers
Требуется найти сумму чисел < 10 000, таких, что сумма их делителей совпадает с суммой делителей суммы делителей.

### Обычное решение (нехвостовая рекурсия)
```erlang

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
```

### Решение с использованием map
```erlang
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
```