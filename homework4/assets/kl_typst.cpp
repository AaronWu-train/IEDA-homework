#include <bits/stdc++.h>
using namespace std;

struct SwapStep {
    int a;
    int b;
    int gain;
};

class KernighanLinTypst {
   private:
    int                 n;
    vector<string>      name;
    vector<vector<int>> w;
    vector<int>         side;  // 0 = A, 1 = B

    int cutCost() const {
        int cost = 0;
        for (int i = 0; i < n; ++i) {
            for (int j = i + 1; j < n; ++j) {
                if (side[i] != side[j]) cost += w[i][j];
            }
        }
        return cost;
    }

    int internalCost(int v) const {
        int sum = 0;
        for (int u = 0; u < n; ++u) {
            if (u != v && side[u] == side[v]) sum += w[v][u];
        }
        return sum;
    }

    int externalCost(int v) const {
        int sum = 0;
        for (int u = 0; u < n; ++u) {
            if (side[u] != side[v]) sum += w[v][u];
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

    void actuallySwap(int x, int y) { swap(side[x], side[y]); }

    string setToTypst(int targetSide) const {
        string s     = "$ {";
        bool   first = true;
        for (int i = 0; i < n; ++i) {
            if (side[i] == targetSide) {
                if (!first) s += ", ";
                s += name[i];
                first = false;
            }
        }
        s += "} $";
        return s;
    }

    string partitionToTypst() const {
        return "$ A = " + setBody(0) + ", quad B = " + setBody(1) + " $";
    }

    string setBody(int targetSide) const {
        string s     = "{";
        bool   first = true;
        for (int i = 0; i < n; ++i) {
            if (side[i] == targetSide) {
                if (!first) s += ", ";
                s += name[i];
                first = false;
            }
        }
        s += "}";
        return s;
    }

    string sumExprForCostOfVertex(int v, bool external) const {
        vector<int> terms;
        for (int u = 0; u < n; ++u) {
            if (u == v) continue;
            if (external && side[u] != side[v]) terms.push_back(w[v][u]);
            if (!external && side[u] == side[v]) terms.push_back(w[v][u]);
        }

        if (terms.empty()) return "0";

        string s;
        for (int i = 0; i < (int)terms.size(); ++i) {
            if (i) s += " + ";
            s += to_string(terms[i]);
        }
        return s;
    }

    string initialCutExpr() const {
        vector<string> groups;
        for (int i = 0; i < n; ++i) {
            if (side[i] != 0) continue;

            vector<int> terms;
            for (int j = 0; j < n; ++j) {
                if (side[j] == 1) terms.push_back(w[i][j]);
            }

            string g = "(";
            for (int k = 0; k < (int)terms.size(); ++k) {
                if (k) g += " + ";
                g += to_string(terms[k]);
            }
            g += ")";
            groups.push_back(g);
        }

        string s;
        for (int i = 0; i < (int)groups.size(); ++i) {
            if (i) s += " + ";
            s += groups[i];
        }
        return s;
    }

    void printIED(const vector<int>& locked) const {
        cout << "#table(\n";
        cout << "  columns: 5,\n";
        cout << "  [Vertex], [$I$], [$E$], [$D = E - I$], [Locked],\n";

        for (int v = 0; v < n; ++v) {
            int I = internalCost(v);
            int E = externalCost(v);
            int D = E - I;

            cout << "  [$" << name[v] << "$], ";
            cout << "[$" << sumExprForCostOfVertex(v, false) << " = " << I
                 << "$], ";
            cout << "[$" << sumExprForCostOfVertex(v, true) << " = " << E
                 << "$], ";
            cout << "[$" << E << " - " << I << " = " << D << "$], ";
            cout << "[" << (locked[v] ? "yes" : "no") << "],\n";
        }

        cout << ")\n\n";
    }

   public:
    KernighanLinTypst(vector<string>      vertexNames,
                      vector<vector<int>> weightMatrix, vector<int> initialSide)
        : n((int)vertexNames.size()),
          name(move(vertexNames)),
          w(move(weightMatrix)),
          side(move(initialSide)) {}

    void run() {
        cout << "= Kernighan-Lin Algorithm\n\n";

        cout << "=== Initial partition\n\n";
        cout << "$ A = " << setBody(0) << ", quad B = " << setBody(1)
             << " $\n\n";
        cout << "$\n";
        cout << "\"Initial cut cost\"= " << initialCutExpr() << " = "
             << cutCost() << "\n";
        cout << "$\n\n";

        int pass = 1;

        while (true) {
            cout << "==== Iteration " << pass << "\n\n";
            cout << "$ A = " << setBody(0) << ", quad B = " << setBody(1)
                 << " $\n\n";
            cout << "$ \"Current cut cost\"= " << cutCost() << " $\n\n";

            vector<int>      locked(n, 0);
            vector<SwapStep> steps;
            int              pairCount = n / 2;

            for (int step = 1; step <= pairCount; ++step) {
                vector<int> D = computeD();

                cout << "==== Step " << step << "\n\n";
                cout << "Current $I$, $E$, and $D$ values:\n\n";
                printIED(locked);

                cout << "Candidate gains:\n\n";

                int bestGain = INT_MIN;
                int bestA = -1, bestB = -1;

                for (int a = 0; a < n; ++a) {
                    if (side[a] != 0 || locked[a]) continue;

                    for (int b = 0; b < n; ++b) {
                        if (side[b] != 1 || locked[b]) continue;

                        int gain = D[a] + D[b] - 2 * w[a][b];

                        cout << "$\n";
                        cout << "g_(" << name[a] << " " << name[b] << ")"
                             << " = D_" << name[a] << " + D_" << name[b]
                             << " - 2 c_(" << name[a] << " " << name[b] << ")"
                             << " = " << D[a] << " + " << D[b] << " - 2 dot "
                             << w[a][b] << " = " << gain << "\n";
                        cout << "$\n\n";

                        if (gain > bestGain) {
                            bestGain = gain;
                            bestA    = a;
                            bestB    = b;
                        }
                    }
                }

                cout << "Therefore, the maximum gain is\n\n";
                cout << "$ hat(g)_" << step << " = g_(" << name[bestA] << " "
                     << name[bestB] << ")"
                     << " = " << bestGain << " $\n\n";

                cout << "Temporarily swap $" << name[bestA] << "$ and $"
                     << name[bestB] << "$, and lock them.\n\n";

                steps.push_back({bestA, bestB, bestGain});
                actuallySwap(bestA, bestB);
                locked[bestA] = 1;
                locked[bestB] = 1;
            }

            cout << "==== Summary of Iteration " << pass << "\n\n";

            int sum            = 0;
            int bestPartialSum = INT_MIN;
            int bestK          = -1;

            cout << "$\n";
            cout << "aligned(\n";

            for (int i = 0; i < (int)steps.size(); ++i) {
                sum += steps[i].gain;

                cout << "  hat(g)_" << (i + 1) << " &= g_(" << name[steps[i].a]
                     << name[steps[i].b] << ")"
                     << " = " << steps[i].gain;

                if (i + 1 != (int)steps.size())
                    cout << ", \\\\\n";
                else
                    cout << "\n";

                if (sum > bestPartialSum) {
                    bestPartialSum = sum;
                    bestK          = i + 1;
                }
            }

            cout << ")\n";
            cout << "$\n\n";

            cout << "The partial sums are:\n\n";

            sum = 0;
            cout << "$\n";
            cout << "aligned(\n";

            for (int i = 0; i < (int)steps.size(); ++i) {
                sum += steps[i].gain;

                cout << "  G_" << (i + 1) << " &= sum_(j=1)^" << (i + 1)
                     << " hat(g)_j = " << sum;

                if (i + 1 != (int)steps.size())
                    cout << ", \\\\\n";
                else
                    cout << "\n";
            }

            cout << ")\n";
            cout << "$\n\n";

            cout << "Thus,\n\n";
            cout << "$ max_k G_k = " << bestPartialSum
                 << " quad \"at\" quad k = " << bestK << " $\n\n";

            // Roll back all temporary swaps.
            for (int i = (int)steps.size() - 1; i >= 0; --i) {
                actuallySwap(steps[i].a, steps[i].b);
            }

            if (bestPartialSum <= 0) {
                cout << "Since the largest partial sum is not positive, the "
                        "algorithm stops.\n\n";
                break;
            }

            cout
                << "Since the largest partial sum is positive, apply the first "
                << bestK << " swap(s):\n\n";

            for (int i = 0; i < bestK; ++i) {
                cout << "- Swap $" << name[steps[i].a] << "$ and $"
                     << name[steps[i].b] << "$.\n";
                actuallySwap(steps[i].a, steps[i].b);
            }

            cout << "\nAfter applying the selected swap(s),\n\n";
            cout << "$ A = " << setBody(0) << ", quad B = " << setBody(1)
                 << " $\n\n";
            cout << "$ New\\ cut\\ cost = " << cutCost() << " $\n\n";

            ++pass;
        }

        cout << "=== Final result\n\n";
        cout << "$ A = " << setBody(0) << ", quad B = " << setBody(1)
             << " $\n\n";
        cout << "$ Final\\ cut\\ cost = " << cutCost() << " $\n";
    }
};

int main() {
    vector<string> names = {"a", "b", "c", "d", "e", "f"};

    vector<vector<int>> w = {
        {0, 2, 1, 3, 3, 2},
        {2, 0, 0, 2, 4, 1},
        {1, 0, 0, 0, 2, 2},
        {3, 2, 0, 0, 1, 0},
        {3, 4, 2, 1, 0, 1},
        {2, 1, 2, 0, 1, 0}
    };

    // A = {a, b, c}, B = {d, e, f}
    // 0 means A, 1 means B.
    vector<int> initialSide = {0, 0, 0, 1, 1, 1};

    KernighanLinTypst kl(names, w, initialSide);
    kl.run();

    return 0;
}