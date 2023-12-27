class UnionFind {
  late List<int> parent;
  late List<int> rank;

  UnionFind(int size) {
    parent = List.generate(size, (i) => i);
    rank = List.filled(size, 0);
  }

  // Find the root of the set in which element 'i' belongs
  int find(int i) {
    if (parent[i] != i) {  // path compression
      parent[i] = find(parent[i]);
    }
    return parent[i];
  }

  // Union (merge) two sets. Returns true if merged, false if already in the same set
  bool union(int i, int j) {
    int rootI = find(i);
    int rootJ = find(j);

    if (rootI == rootJ) {
      return false;  // already in the same set
    }

    // Attach smaller rank tree under root of high rank tree (Union by Rank)
    if (rank[rootI] < rank[rootJ]) {
      parent[rootI] = rootJ;
    } else if (rank[rootJ] < rank[rootI]) {
      parent[rootJ] = rootI;
    } else {
      parent[rootJ] = rootI;
      rank[rootI] += 1;
    }

    return true;
  }
}
