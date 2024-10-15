
def naive_solution() -> int:
    for a in range(1, 1000):
        for b in range(1, 1000):
            c = 1000 - a - b
            if a + b + c == 1000 and a**2 + b**2 == c**2:
                    return a * b * c
                
                
if __name__ == "__main__":
    print(naive_solution())