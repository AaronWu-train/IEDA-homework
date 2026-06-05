w = [1, 3, 1, 2, 3]
x = [0, 2, 6, 8, 5]
y = [0, 5, 9, 1, 4]

cost = 999999999
best_x, best_y = 0, 0

for i in range(10):
    for j in range(10):
        c = 0
        if (i, j) in zip(x, y):
            continue
        for k in range(5):
            c += w[k] * (abs(x[k] - i) + abs(y[k] - j))
        if c < cost:
            cost = c
            best_x, best_y = i, j

print("Best location: ({}, {}) with cost {}".format(best_x, best_y, cost))
