# DAGON Technology Mapping

This folder contains a C++ implementation of DAGON-style technology mapping for
directed acyclic logic graphs.

Given a subject graph and a set of library pattern graphs, the program computes
the minimum mapping cost for each subject node. Pattern `PI` nodes are treated as
cut boundaries, so a pattern can match a subject subgraph and reuse the already
computed dynamic-programming cost at its boundary inputs.

## Files

- `dagon.cpp`: Basic implementation of DAGON dynamic programming.
- `dagon_improve.cpp`: Improved version that inserts two inverters on every original edge before mapping. This allows extra `INV` / `buf` opportunities.

## Supported Gates

The parser accepts the following gate types:

- `PI` or `IN`
- `INV`
- `NAND`
- `NOR`

`NAND` and `NOR` are treated as commutative gates when matching fanins.

## Input Format

The input first describes the subject graph:

```text
ns ms
s0 s1 ... s(ns-1)
a0 b0
a1 b1
...
a(ms-1) b(ms-1)
```

- `ns`: number of subject nodes
- `ms`: number of subject edges
- `si`: gate type of subject node `i`
- `a b`: directed edge from node `a` to node `b`

After that, the input describes the pattern library:

```text
p
name cost
n m root
g0 g1 ... g(n-1)
u0 v0
u1 v1
...
u(m-1) v(m-1)
```

The pattern block is repeated `p` times.

- `name`: pattern cell name
- `cost`: pattern cell cost
- `n`: number of pattern nodes
- `m`: number of pattern edges
- `root`: root node of the pattern graph
- `gi`: gate type of pattern node `i`
- `u v`: directed edge from pattern node `u` to pattern node `v`

The sample `input.txt` contains 18 subject nodes, 17 subject edges, and 10
library patterns including `inv`, `buf`, `nand2`, `and2`, `nand3`, `or2`,
`aoi21`, `oai21`, `aoi22`, and `nand4`.

## Algorithm

1. Topologically sort the subject graph.
2. Initialize primary input nodes with cost `0`.
3. Visit subject nodes in topological order.
4. For each subject node, try every pattern root.
5. Recursively match the pattern tree against the subject fanin cone.
6. When a pattern `PI` is reached, stop matching and use the subject node's
   existing DP cost as the boundary cost.
7. Store the minimum `pattern cost + boundary cost` for the subject node.
8. Sum the DP costs of output nodes, where output nodes are nodes with no
   fanout in the original subject graph.

The improved version performs the same DP after transforming every original
edge:

```text
u -> v
```

into:

```text
u -> INV -> INV -> v
```

This preserves logic while exposing additional inverter-pair choices during
technology mapping.

## Build

```bash
g++ -std=c++17 -O2 dagon.cpp -o dagon.out
g++ -std=c++17 -O2 dagon_improve.cpp -o dagon_improve.out
```

## Run

```bash
./dagon.out < input.txt > output.txt
./dagon_improve.out < input.txt > output_improve.txt
```

## Example Result

For the provided `input.txt`, the basic implementation reports:

```text
Minimum total cost = 15
```

The improved implementation reports:

```text
Minimum total cost = 17
```

`output_improve.txt` also prints the original subject nodes separately from the
inserted inverter-pair nodes.
