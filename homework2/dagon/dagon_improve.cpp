// dagon_inprove.cpp
#include <bits/stdc++.h>
using namespace std;

#define ll long long
#define pb push_back
#define endl '\n'

const ll INF = (ll)4e18;

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

string gate2str(GateType t) {
    if (t == GateType::PI) return "PI";
    if (t == GateType::INV) return "INV";
    if (t == GateType::NAND) return "NAND";
    if (t == GateType::NOR) return "NOR";
    return "?";
}

bool isCommutative(GateType t) {
    return t == GateType::NAND || t == GateType::NOR;
}

struct Node {
    int id;
    GateType type;
    vector<int> fanin;
    vector<int> fanout;

    Node() {}
    Node(int i, GateType g) : id(i), type(g) {}
};

struct Pattern {
    string name;
    ll cost;
    int root;
    vector<Node> g;
};

void addEdge(vector<Node> &g, int u, int v) {
    g[u].fanout.pb(v);
    g[v].fanin.pb(u);
}

vector<int> topological_sort(vector<Node> &g) {
    int n = (int)g.size();
    vector<int> indeg(n), order;
    queue<int> q;

    for (int i = 0; i < n; i++) {
        indeg[i] = (int)g[i].fanin.size();
        if (indeg[i] == 0) q.push(i);
    }

    while (!q.empty()) {
        int u = q.front();
        q.pop();

        order.pb(u);

        for (int v : g[u].fanout) {
            if (--indeg[v] == 0) q.push(v);
        }
    }

    if ((int)order.size() != n) {
        cerr << "Error: graph is not a DAG." << endl;
        exit(1);
    }

    return order;
}

// 對 subject graph 每條原始 edge u -> v 插入兩個 INV：
// u -> inv1 -> inv2 -> v
void insertInverterPairs(vector<Node> &sg,
                         const vector<pair<int,int>> &edges,
                         vector<char> &isInserted) {
    for (auto &x : sg) {
        x.fanin.clear();
        x.fanout.clear();
    }

    for (auto [u, v] : edges) {
        int inv1 = (int)sg.size();
        sg.pb(Node(inv1, GateType::INV));
        isInserted.pb(true);

        int inv2 = (int)sg.size();
        sg.pb(Node(inv2, GateType::INV));
        isInserted.pb(true);

        addEdge(sg, u, inv1);
        addEdge(sg, inv1, inv2);
        addEdge(sg, inv2, v);
    }
}

// 回傳 pattern subtree match 到 subject subtree 後的 boundary dp cost 總和。
// 若不能 match，回傳 INF。
ll matchCost(int sid, int pid,
             vector<Node> &sg,
             vector<Node> &pg,
             vector<ll> &dp,
             vector<char> &isInserted) {

    Node &s = sg[sid];
    Node &pnode = pg[pid];

    // pattern 的 PI 是 boundary，可以停在任何 subject node
    if (pnode.type == GateType::PI) {
        return dp[sid];
    }

    ll bestSkip = INF;

    // 嘗試跳過 virtual INV pair:
    // u -> inv1 -> inv2
    // sid = inv2 時，可以直接嘗試 match u
    if (isInserted[sid] &&
        s.type == GateType::INV &&
        s.fanin.size() == 1) {

        int inv1 = s.fanin[0];

        if (isInserted[inv1] &&
            sg[inv1].type == GateType::INV &&
            sg[inv1].fanin.size() == 1) {

            int u = sg[inv1].fanin[0];

            bestSkip = matchCost(u, pid, sg, pg, dp, isInserted);
        }
    }

    if (s.type != pnode.type) return bestSkip;
    if (s.fanin.size() != pnode.fanin.size()) return bestSkip;

    int n = (int)s.fanin.size();

    vector<int> idx(n);
    iota(idx.begin(), idx.end(), 0);

    ll best = INF;

    do {
        ll total = 0;
        bool ok = true;

        for (int i = 0; i < n; i++) {
            int s_child = s.fanin[idx[i]];
            int p_child = pnode.fanin[i];

            ll sub = matchCost(s_child, p_child, sg, pg, dp, isInserted);

            if (sub >= INF) {
                ok = false;
                break;
            }

            total += sub;

            if (total >= INF) {
                ok = false;
                break;
            }
        }

        if (ok) best = min(best, total);

    } while (isCommutative(s.type) &&
             next_permutation(idx.begin(), idx.end()));

    return min(best, bestSkip);
}

int32_t main() {
    ios::sync_with_stdio(0);cin.tie(0);cout.tie(0);
    int ns, ms;
    cin >> ns >> ms;

    vector<Node> sg(ns);

    for (int i = 0; i < ns; i++) {
        string t;
        cin >> t;
        sg[i] = Node(i, s2gate_type(t));
    }

    vector<pair<int,int>> original_edges;

    for (int i = 0; i < ms; i++) {
        int a, b;
        cin >> a >> b;
        original_edges.pb({a, b});
        addEdge(sg, a, b);
    }

    // 記錄原始 output，因為後面會清掉並重建 edge
    vector<int> original_outputs;
    for (int i = 0; i < ns; i++) {
        if (sg[i].fanout.empty()) original_outputs.pb(i);
    }

    // improve DAGON：每條 wire 插入兩個 INV
    vector<char> isInserted(ns, false);
    insertInverterPairs(sg, original_edges, isInserted);

    int p;
    cin >> p;

    vector<Pattern> patterns;

    for (int i = 0; i < p; i++) {
        Pattern pat;
        cin >> pat.name >> pat.cost;

        int n, m, r;
        cin >> n >> m >> r;

        pat.root = r;
        pat.g.resize(n);

        for (int j = 0; j < n; j++) {
            string t;
            cin >> t;
            pat.g[j] = Node(j, s2gate_type(t));
        }

        for (int j = 0; j < m; j++) {
            int a, b;
            cin >> a >> b;
            addEdge(pat.g, a, b);
        }

        patterns.pb(pat);
    }

    vector<int> order = topological_sort(sg);

    int nsg = (int)sg.size();
    vector<ll> dp(nsg, INF);
    vector<int> choose(nsg, -1);

    for (int v : order) {
        if (sg[v].type == GateType::PI) {
            dp[v] = 0;
            continue;
        }

        for (int i = 0; i < (int)patterns.size(); i++) {
            ll boundary_cost = matchCost(v, patterns[i].root, sg, patterns[i].g, dp, isInserted);

            if (boundary_cost >= INF) continue;

            ll total_cost = patterns[i].cost + boundary_cost;

            if (total_cost < dp[v]) {
                dp[v] = total_cost;
                choose[v] = i;
            }
        }
    }

    ll ans = 0;
    for (int out : original_outputs) {
        ans += dp[out];
    }

    cout << "Minimum total cost = " << ans << endl;

    cout << endl;
    cout << "[Original nodes]" << endl;
    for (int i = 0; i < ns; i++) {
        cout << "node " << i << " (" << gate2str(sg[i].type) << "): ";

        if (sg[i].type == GateType::PI) {
            cout << "PI, cost = 0";
        } else {
            cout << "cost = " << dp[i];

            if (choose[i] != -1) {
                cout << ", cell = " << patterns[choose[i]].name;
            } else {
                cout << ", cell = NONE";
            }
        }

        bool is_output = false;
        for (int out : original_outputs) {
            if (out == i) is_output = true;
        }
        if (is_output) cout << "  [OUTPUT]";

        cout << endl;
    }

    cout << endl;
    cout << "[Inserted inverter-pair nodes]" << endl;

    for (int i = ns; i < nsg; i++) {
        cout << "node " << i << " (" << gate2str(sg[i].type) << "): ";
        cout << "cost = " << dp[i];

        if (choose[i] != -1) {
            cout << ", cell = " << patterns[choose[i]].name;
        } else {
            cout << ", cell = NONE";
        }

        cout << endl;
    }

    return 0;
}
