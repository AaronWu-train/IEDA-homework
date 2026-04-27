#pragma GCC optimize("Ofast")
#include <bits/stdc++.h>
using namespace std;
#define ll long long
#define pb push_back
#define endl '\n'
#define AI(x) begin(x),end(x)
#ifdef DEBUG 
#define debug(args...) LKJ("\033[1;32m[ "+string(#args)+" ]\033[0m", args)
template<class I> void LKJ(I&&x){ cerr << x << '\n'; }
template<class I, class...T> void LKJ(I&&x, T&&...t){ cerr << x << ", ", LKJ(t...); }
template<class I> void OI(I a, I b){ while(a < b) cerr << *a << " \n"[next(a) == b], ++a; }
#else
#define debug(...) 0
#define OI(...) 0
#endif
#define _ ios::sync_with_stdio(0);cin.tie(0);cout.tie(0);

const int INF = 1e9;

enum class GateType {
    PI,
    INV,
    NAND,
    NOR,
};

string toUpper(string s) {
    for (char &c : s) c = toupper(c);
    return s;
}

GateType s2gate_type(string s) {
    s = toUpper(s);

    if (s == "PI" || s == "IN") return GateType::PI;
    if (s == "INV") return GateType::INV;
    if (s == "NAND") return GateType::NAND;
    if (s == "NOR") return GateType::NOR;

    cerr << "Unknown gate type: " << s << endl;
    exit(1);
}

bool isCommutative(GateType t) {
    return t == GateType::NAND || t == GateType::NOR;
}

struct node {
    int id;
    GateType type;
    vector<int> fanin;
    vector<int> fanout;

    node() {}
    node(int i, GateType g) : id(i), type(g) {}
};

vector<int> topological_sort(vector<node>& g) {
    int n = g.size();
    vector<int> indeg(n), order;
    queue<int> q;

    for (int i = 0; i < n; i++) {
        indeg[i] = g[i].fanin.size();
        if (indeg[i] == 0) q.push(i);
    }

    while (!q.empty()) {
        int u = q.front();
        q.pop();

        order.pb(u);

        for (int v : g[u].fanout) {
            indeg[v]--;
            if (indeg[v] == 0) q.push(v);
        }
    }

    return order;
}

// 回傳 pattern subtree match 到 subject subtree 後，boundary dp cost 總和
// 若不能 match，回傳 INF
int matchCost(int sid, int pid,
              vector<node>& sg,
              vector<node>& pg,
              vector<int>& dp) {

    node& s = sg[sid];
    node& p = pg[pid];

    if (p.type == GateType::PI) {
        return dp[sid];
    }

    if (s.type != p.type) return INF;
    if (s.fanin.size() != p.fanin.size()) return INF;

    int n = s.fanin.size();

    vector<int> idx(n);
    iota(idx.begin(), idx.end(), 0);

    int best = INF;

    do {
        int total = 0;
        bool ok = true;

        for (int i = 0; i < n; i++) {
            int s_child = s.fanin[idx[i]];
            int p_child = p.fanin[i];

            int sub = matchCost(s_child, p_child, sg, pg, dp);

            if (sub >= INF) {
                ok = false;
                break;
            }

            total += sub;
        }

        if (ok) best = min(best, total);

    } while (isCommutative(s.type) &&
             next_permutation(idx.begin(), idx.end()));

    return best;
}

signed main() {_
    int ns, ms;
    cin >> ns >> ms;

    vector<node> sg(ns);

    for (int i = 0; i < ns; i++) {
        string t;
        cin >> t;
        sg[i] = node(i, s2gate_type(t));
    }

    for (int i = 0; i < ms; i++) {
        int a, b;
        cin >> a >> b;

        sg[a].fanout.pb(b);
        sg[b].fanin.pb(a);
    }

    vector<int> subject_order = topological_sort(sg);

    int p;
    cin >> p;

    vector<vector<node>> patterns(p);
    vector<int> cost(p);
    vector<string> name(p);
    vector<int> root(p);

    for (int i = 0; i < p; i++) {
        cin >> name[i] >> cost[i];

        int n, m, r;
        cin >> n >> m >> r;

        root[i] = r;
        patterns[i].resize(n);

        for (int j = 0; j < n; j++) {
            string t;
            cin >> t;
            patterns[i][j] = node(j, s2gate_type(t));
        }

        for (int j = 0; j < m; j++) {
            int a, b;
            cin >> a >> b;

            patterns[i][a].fanout.pb(b);
            patterns[i][b].fanin.pb(a);
        }
    }

    vector<int> dp(ns, INF);
    vector<int> choose(ns, -1);

    for (int v : subject_order) {
        if (sg[v].type == GateType::PI) {
            dp[v] = 0;
            continue;
        }

        for (int i = 0; i < p; i++) {
            int boundary_cost = matchCost(v, root[i], sg, patterns[i], dp);

            if (boundary_cost >= INF) continue;

            int total_cost = cost[i] + boundary_cost;

            if (total_cost < dp[v]) {
                dp[v] = total_cost;
                choose[v] = i;
            }
        }
    }

    // 預設所有 fanout empty 的 node 都是 output
    int ans = 0;

    for (int i = 0; i < ns; i++) {
        if (sg[i].fanout.empty()) {
            ans += dp[i];
        }
    }

    cout << "Minimum total cost = " << ans << endl;

    for (int i = 0; i < ns; i++) {
        cout << "node " << i << ": ";

        if (sg[i].fanin.empty()) {
            cout << "PI, cost = 0" << endl;
        } else {
            cout << "cost = " << dp[i];

            if (choose[i] != -1) {
                cout << ", cell = " << name[choose[i]];
            } else {
                cout << ", cell = NONE";
            }

            cout << endl;
        }
    }

    return 0;
}
