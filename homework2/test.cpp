#include <bits/stdc++.h>
using namespace std;

struct Cube {
    string bits;      // e.g. 10-0-
    set<int> mins;    // minterms covered during merging

    bool operator<(const Cube& other) const {
        if (bits != other.bits) return bits < other.bits;
        return mins < other.mins;
    }
};

int N;

string to_binary(int x) {
    string s(N, '0');
    for (int i = N - 1; i >= 0; --i) {
        s[i] = char('0' + (x & 1));
        x >>= 1;
    }
    return s;
}

int count_ones(const string& s) {
    return count(s.begin(), s.end(), '1');
}

bool combine(const string& a, const string& b, string& out) {
    int diff = 0;
    out = a;

    for (int i = 0; i < N; ++i) {
        if (a[i] != b[i]) {
            if (a[i] == '-' || b[i] == '-') return false;
            diff++;
            out[i] = '-';
        }
    }

    return diff == 1;
}

bool covers(const string& cube, int m) {
    string b = to_binary(m);

    for (int i = 0; i < N; ++i) {
        if (cube[i] != '-' && cube[i] != b[i]) {
            return false;
        }
    }

    return true;
}

int literal_count(const string& cube) {
    int cnt = 0;
    for (char c : cube) {
        if (c != '-') cnt++;
    }
    return cnt;
}

string cube_to_expr(const string& cube) {
    string res;

    for (int i = 0; i < N; ++i) {
        if (cube[i] == '-') continue;

        char var = char('a' + i);

        if (!res.empty()) res += " ";

        res += var;
        if (cube[i] == '0') res += "'";
    }

    if (res.empty()) return "1";
    return res;
}

vector<Cube> unique_cubes(const vector<Cube>& cubes) {
    map<string, set<int>> mp;

    for (auto& c : cubes) {
        mp[c.bits].insert(c.mins.begin(), c.mins.end());
    }

    vector<Cube> res;
    for (auto& [bits, mins] : mp) {
        res.push_back({bits, mins});
    }

    return res;
}

vector<Cube> generate_primes(const vector<int>& fd) {
    vector<Cube> current;

    for (int m : fd) {
        current.push_back({to_binary(m), {m}});
    }

    vector<Cube> primes;

    while (true) {
        map<int, vector<Cube>> groups;

        for (auto& c : current) {
            groups[count_ones(c.bits)].push_back(c);
        }

        vector<Cube> next;
        set<string> used;
        bool merged_any = false;

        for (auto& [k, g1] : groups) {
            if (!groups.count(k + 1)) continue;

            for (auto& a : g1) {
                for (auto& b : groups[k + 1]) {
                    string merged;
                    if (combine(a.bits, b.bits, merged)) {
                        merged_any = true;

                        used.insert(a.bits);
                        used.insert(b.bits);

                        Cube c;
                        c.bits = merged;
                        c.mins = a.mins;
                        c.mins.insert(b.mins.begin(), b.mins.end());

                        next.push_back(c);
                    }
                }
            }
        }

        for (auto& c : current) {
            if (!used.count(c.bits)) {
                primes.push_back(c);
            }
        }

        if (!merged_any) break;

        current = unique_cubes(next);
    }

    return unique_cubes(primes);
}

int main() {
    cin >> N;

    int f_cnt;
    cin >> f_cnt;

    vector<int> F(f_cnt);
    for (int i = 0; i < f_cnt; ++i) cin >> F[i];

    int d_cnt;
    cin >> d_cnt;

    vector<int> D(d_cnt);
    for (int i = 0; i < d_cnt; ++i) cin >> D[i];

    vector<int> FD = F;
    FD.insert(FD.end(), D.begin(), D.end());

    sort(FD.begin(), FD.end());
    FD.erase(unique(FD.begin(), FD.end()), FD.end());

    sort(F.begin(), F.end());

    // Step 1: generate prime implicants from F ∪ D
    vector<Cube> primes = generate_primes(FD);

    cout << "Prime implicants:\n";
    for (int i = 0; i < (int)primes.size(); ++i) {
        cout << "P" << i + 1 << " = "
             << primes[i].bits << " = "
             << cube_to_expr(primes[i].bits) << "\n";
    }

    // Step 2: Boolean matrix
    int R = F.size();
    int C = primes.size();

    vector<vector<int>> B(R, vector<int>(C, 0));

    for (int i = 0; i < R; ++i) {
        for (int j = 0; j < C; ++j) {
            B[i][j] = covers(primes[j].bits, F[i]);
        }
    }

    cout << "\nBoolean matrix:\n";
    cout << setw(8) << "";
    for (int j = 0; j < C; ++j) {
        cout << setw(5) << ("P" + to_string(j + 1));
    }
    cout << "\n";

    for (int i = 0; i < R; ++i) {
        cout << setw(8) << ("m" + to_string(F[i]));
        for (int j = 0; j < C; ++j) {
            cout << setw(5) << B[i][j];
        }
        cout << "\n";
    }

    // Step 3: essential prime implicants
    vector<int> selected;
    vector<int> covered(R, 0);

    for (int i = 0; i < R; ++i) {
        vector<int> ones;

        for (int j = 0; j < C; ++j) {
            if (B[i][j]) ones.push_back(j);
        }

        if ((int)ones.size() == 1) {
            int p = ones[0];
            if (find(selected.begin(), selected.end(), p) == selected.end()) {
                selected.push_back(p);
            }
        }
    }

    for (int p : selected) {
        for (int i = 0; i < R; ++i) {
            if (B[i][p]) covered[i] = 1;
        }
    }

    cout << "\nEssential prime implicants:\n";
    if (selected.empty()) {
        cout << "(none)\n";
    } else {
        for (int p : selected) {
            cout << "P" << p + 1 << " = "
                 << cube_to_expr(primes[p].bits) << "\n";
        }
    }

    // Step 4: brute-force minimum cover for remaining rows
    vector<int> candidates;
    for (int j = 0; j < C; ++j) {
        if (find(selected.begin(), selected.end(), j) == selected.end()) {
            candidates.push_back(j);
        }
    }

    int M = candidates.size();
    int best_terms = INT_MAX;
    int best_literals = INT_MAX;
    set<vector<int>> solutions;

    for (int mask = 0; mask < (1 << M); ++mask) {
        vector<int> chosen = selected;

        for (int i = 0; i < M; ++i) {
            if (mask & (1 << i)) {
                chosen.push_back(candidates[i]);
            }
        }

        bool ok = true;

        for (int r = 0; r < R; ++r) {
            bool row_ok = false;

            for (int p : chosen) {
                if (B[r][p]) {
                    row_ok = true;
                    break;
                }
            }

            if (!row_ok) {
                ok = false;
                break;
            }
        }

        if (!ok) continue;

        sort(chosen.begin(), chosen.end());
        chosen.erase(unique(chosen.begin(), chosen.end()), chosen.end());

        int terms = chosen.size();
        int literals = 0;

        for (int p : chosen) {
            literals += literal_count(primes[p].bits);
        }

        if (terms < best_terms || (terms == best_terms && literals < best_literals)) {
            best_terms = terms;
            best_literals = literals;
            solutions.clear();
            solutions.insert(chosen);
        } else if (terms == best_terms && literals == best_literals) {
            solutions.insert(chosen);
        }
    }

    cout << "\nMinimum covers:\n";
    int idx = 1;

    for (auto sol : solutions) {
        cout << "G*" << idx++ << " = ";

        for (int i = 0; i < (int)sol.size(); ++i) {
            if (i) cout << " + ";
            cout << cube_to_expr(primes[sol[i]].bits);
        }

        cout << "\n";
    }

    return 0;
}