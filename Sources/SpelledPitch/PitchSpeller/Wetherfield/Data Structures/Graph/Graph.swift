//
//  Graph.swift
//  SpelledPitch
//
//  Created by James Bean on 9/22/18.
//

/// Unweighted, undirected graph.
struct Graph <Node: Hashable>: UnweightedGraphProtocol, UndirectedGraphProtocol {
    typealias Edge = UnorderedPair<Node>
    var nodes: Set<Node>
    var edges: Set<Edge>

    init(_ nodes: Set<Node> = []) {
        self.nodes = nodes
        self.edges = []
    }
    
    init(_ nodes: Set<Node> = [], _ edges: Set<Edge> = []) {
        self.init(nodes)
        self.edges = edges
    }
}

extension Graph: Equatable { }
extension Graph: Hashable { }
