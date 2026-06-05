#include <bits/stdc++.h>
using namespace std;

struct SwapStep {
    int a;  // index in original vertex list, originally/currently in A side
    int b;  // index in original vertex list, originally/currently in B side
    int gain;
};

class KernighanLin {
   private:
    int                 n;
    vector<string>      name;
    vector<vector<int>> w;
    vector<int>         side;  // 0 = A, 1 = B

    int cutCost() const {
        int cost = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                if (side[i] != side[j]) {
                    cost += w[i][j];
                }
            }
        }
        return cost;
    }

    vector<int> getSet(int targetSide) const {
        vector<int> result;
        for (int i = 0; i < n; ++i) {
            if (side[i] == targetSide) {
                result.push_back(i);
            }
        }
        return result;
    }

    int internalCost(int v) const {
        int sum = 0;
        for (int u = 0; u < n; ++u) {
            if (u != v && side[u] == side[v]) {
                sum += w[v][u];
            }
        }
        return sum;
    }

    int externalCost(int v) const {
        int sum = 0;
        for (int u = 0; u < n; ++u) {
            if (side[u] != side[v]) {
                sum += w[v][u];
            }
        }
        return sum;
    }

    vector<int> computeD() const {
        vector<int> D(n);
        for (int v = 0; v < n; ++v) {
            D[v] = externalCost(v) - internalCost(v);
        }
        return D;
    }

    void printPartition() const {
        cout << "A = {";
        bool first = true;
        for (int i = 0; i < n; ++i) {
            if (side[i] == 0) {
                if (!first) cout << ", ";
                cout << name[i];
                first = false;
            }
        }
        cout << "}, B = {";
        first = true;
        for (int i = 0; i < n; ++i) {
            if (side[i] == 1) {
                if (!first) cout << ", ";
                cout << name[i];
                first = false;
            }
        }
        cout << "}\n";
    }

    void printIED(const vector<int>& locked) const {
        cout << "I, E, D values:\n";
        cout << left << setw(8) << "v" << setw(8) << "I" << setw(8) << "E"
             << setw(8) << "D" << setw(10) << "locked"
             << "\n";

        for (int v = 0; v < n; ++v) {
            int I = internalCost(v);
            int E = externalCost(v);
            int D = E - I;

            cout << left << setw(8) << name[v] << setw(8) << I << setw(8) << E
                 << setw(8) << D << setw(10) << (locked[v] ? "yes" : "no")
                 << "\n";
        }
    }

    void actuallySwap(int x, int y) { swap(side[x], side[y]); }

   public:
    KernighanLin(vector<string> vertexNames, vector<vector<int>> weightMatrix,
                 vector<int> initialSide)
        : n((int)vertexNames.size()),
          name(move(vertexNames)),
          w(move(weightMatrix)),
          side(move(initialSide)) {}

    void run() {
        cout << "Initial partition:\n";
        printPartition();
        cout << "Initial cut cost = " << cutCost() << "\n\n";

        int pass = 1;

        while (true) {
            cout << "==============================\n";
            cout << "Iteration " << pass << "\n";
            cout << "Current partition:\n";
            printPartition();
            cout << "Current cut cost = " << cutCost() << "\n\n";

            vector<int>      locked(n, 0);
            vector<SwapStep> steps;

            int pairCount = n / 2;

            for (int step = 1; step <= pairCount; ++step) {
                vector<int> D = computeD();

                cout << "Step " << step << ":\n";
                printIED(locked);
                cout << "\nCandidate gains:\n";

                int bestGain = INT_MIN;
                int bestA = -1, bestB = -1;

                for (int a = 0; a < n; ++a) {
                    if (side[a] != 0 || locked[a]) continue;

                    for (int b = 0; b < n; ++b) {
                        if (side[b] != 1 || locked[b]) continue;

                        int gain = D[a] + D[b] - 2 * w[a][b];

                        cout << "g(" << name[a] << ", " << name[b] << ")"
                             << " = D_" << name[a] << " + D_" << name[b]
                             << " - 2c_" << name[a] << name[b] << " = " << D[a]
                             << " + " << D[b] << " - 2*" << w[a][b] << " = "
                             << gain << "\n";

                        if (gain > bestGain) {
                            bestGain = gain;
                            bestA    = a;
                            bestB    = b;
                        }
                    }
                }

                cout << "Choose maximum gain pair: " << name[bestA] << " and "
                     << name[bestB] << ", gain = " << bestGain << "\n\n";

                steps.push_back({bestA, bestB, bestGain});

                // Temporarily swap and lock, exactly like KL pass.
                actuallySwap(bestA, bestB);
                locked[bestA] = 1;
                locked[bestB] = 1;
            }

            cout << "Summary of gains:\n";
            int sum            = 0;
            int bestPartialSum = INT_MIN;
            int bestK          = -1;

            for (int i = 0; i < (int)steps.size(); ++i) {
                sum += steps[i].gain;
                cout << "g_" << (i + 1) << " = g(" << name[steps[i].a] << ", "
                     << name[steps[i].b] << ") = " << steps[i].gain
                     << ", partial sum = " << sum << "\n";

                if (sum > bestPartialSum) {
                    bestPartialSum = sum;
                    bestK          = i + 1;
                }
            }

            cout << "\nLargest partial sum = " << bestPartialSum
                 << " at k = " << bestK << "\n";

            // At this moment, all temporary swaps in this pass have been
            // applied. Roll them all back first.
            for (int i = (int)steps.size() - 1; i >= 0; --i) {
                actuallySwap(steps[i].a, steps[i].b);
            }

            if (bestPartialSum <= 0) {
                cout << "No positive improvement. Stop.\n\n";
                break;
            }

            cout << "Apply first " << bestK << " swap(s):\n";
            for (int i = 0; i < bestK; ++i) {
                cout << "Swap " << name[steps[i].a] << " and "
                     << name[steps[i].b] << "\n";
                actuallySwap(steps[i].a, steps[i].b);
            }

            cout << "New partition:\n";
            printPartition();
            cout << "New cut cost = " << cutCost() << "\n\n";

            ++pass;
        }

        cout << "==============================\n";
        cout << "Final result:\n";
        printPartition();
        cout << "Final cut cost = " << cutCost() << "\n";
    }
};

int main() {
    // Example from your problem image:
    // V = {a, b, c, d, e, f}
    vector<string> names = {"a", "b", "c", "d", "e", "f"};

    vector<vector<int>> w = {
        {0, 2, 1, 3, 3, 2},
        {2, 0, 0, 2, 4, 1},
        {1, 0, 0, 0, 2, 2},
        {3, 2, 0, 0, 1, 0},
        {3, 4, 2, 1, 0, 1},
        {2, 1, 2, 0, 1, 0}
    };

    // Initial partition:
    // A = {a, b, c}, B = {d, e, f}
    // side: 0 means A, 1 means B.
    vector<int> initialSide = {0, 0, 0, 1, 1, 1};

    KernighanLin kl(names, w, initialSide);
    kl.run();

    return 0;
}