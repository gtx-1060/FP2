
def naive_solution():
    acc = 0
    for i in range(2, 10_000):
        sum1 = sum_proper_divisors(i)
        sum2 = sum_proper_divisors(sum1)
        if i == sum2 and i != sum1:
            acc += i
    return acc


def sum_proper_divisors(n):
    acc = 1
    for i in range(2, n // 2 + 1):
        if n % i == 0:
            acc += i
    return acc


if __name__ == "__main__":
    print(naive_solution())