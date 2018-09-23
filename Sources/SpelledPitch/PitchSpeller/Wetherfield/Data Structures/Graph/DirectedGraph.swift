//
//  DirectedGraph.swift
//  SpelledPitch
//
//  Created by James Bean on 9/22/18.
//

struct DirectedGraph <Node: Hashable>: UnweightedGraphProtocol, DirectedGraphProtocol {

    typealias Edge = OrderedPair<Node>

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

    func edges(from source: Node) -> Set<Edge> {
        return edges.filter { $0.a == source }
    }
}

extension DirectedGraph: Equatable { }
extension DirectedGraph: Hashable { }
