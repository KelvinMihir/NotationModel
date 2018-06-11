//
//  Wetherfield.swift
//  PitchSpeller
//
//  Created by James Bean on 5/23/18.
//

import Pitch

/// "Namespace" for Wetherfield Pitch Speller.
public enum Wetherfield {

    /// Pitch spelling mechanism which implements the formalization proposed in Wetherfield's thesis
    /// _A Graphical Theory of Musical Pitch Spelling_.
    final class PitchSpeller {

        /// The payload for a FlowNetwork which has not yet been assigned.
        struct UnassignedNodeInfo: Hashable {

            /// The unspelled pitch class and associated identifier which will ultimately be
            /// represented.
            let item: UnspelledPitchItem

            /// Index of the node in the `Box` for the given `pitchClass`. Will be either `0`, or
            /// `1`. This value will ultimately represent the index within a `TendencyPair`.
            let index: Int
        }

        /// The payload for a Flownetwork which has been assigned.
        struct AssignedNodeInfo: Hashable {

            /// The unspelled pitch class and associated identifier which is now representable.
            let item: UnspelledPitchItem

            /// Index of the node in the `Box` for the given `pitchClass`. Will be either `0`, or
            /// `1`. This value will ultimately represent the index within a `TendencyPair`.
            let index: Int

            /// The "tendency" value assigned subsequent to finding the minium cut.
            let tendency: Tendency

            // MARK: - Initializers

            init(_ nodeInfo: UnassignedNodeInfo, tendency: Tendency) {
                self.item = nodeInfo.item
                self.index = nodeInfo.index
                self.tendency = tendency
            }
        }

        /// The `Pitch` values to be spelled.
        let pitches: [Pitch]

        /// The omnipresent tie-breaking pitch class
        let parsimonyPivot: Pitch.Class

        // MARK: - Initializers

        /// Create a `PitchSpeller` to spell the given `pitches`.
        init(pitches: [Pitch], parsimonyPivot: Pitch.Class) {
            self.pitches = pitches
            self.parsimonyPivot = parsimonyPivot
        }

        // MARK: - Instance Methods

        /// - Returns: `FlowNetwork` of `UnassignedNodeInfo`-wrapping nodes.
        func flowNetwork() -> FlowNetwork<UnassignedNodeInfo> {
            var graph = Graph<UnassignedNodeInfo>()
            let source = makeSource(in: &graph)
            let sink = makeSink(in: &graph)
            let internalNodes = makeInternalNodes(in: &graph)
            hookUpNodes(source: source, sink: sink, internalNodes: internalNodes, in: &graph)
            return FlowNetwork(graph, source: source, sink: sink)
        }

        func makeSource(in graph: inout Graph<UnassignedNodeInfo>)
            -> Graph<UnassignedNodeInfo>.Node
        {
            let item = UnspelledPitchItem(identifier: -1, pitchClass: parsimonyPivot)
            let payload = UnassignedNodeInfo(item: item, index: 0)
            return graph.createNode(payload)
        }

        func makeSink(in graph: inout Graph<UnassignedNodeInfo>) -> Graph<UnassignedNodeInfo>.Node {
            let item = UnspelledPitchItem(identifier: -1, pitchClass: parsimonyPivot)
            let payload = UnassignedNodeInfo(item: item, index: 1)
            return graph.createNode(payload)
        }

        func makeInternalNodes(in graph: inout Graph<UnassignedNodeInfo>)
            -> [Graph<UnassignedNodeInfo>.Node]
        {
            var internalNodes: [Graph<UnassignedNodeInfo>.Node] = []
            for (identifier, pitch) in pitches.enumerated() {
                let item = UnspelledPitchItem(identifier: identifier, pitchClass: pitch.class)
                for index in [0,1] {
                    internalNodes.append(
                        graph.createNode(UnassignedNodeInfo(item: item, index: index))
                    )
                }
            }
            return internalNodes
        }

        func hookUpNodes(
            source: Graph<UnassignedNodeInfo>.Node,
            sink: Graph<UnassignedNodeInfo>.Node,
            internalNodes: [Graph<UnassignedNodeInfo>.Node],
            in graph: inout Graph<UnassignedNodeInfo>
        )
        {
            for node in internalNodes {
                graph.insertEdge(from: source, to: node, value: 1)
                graph.insertEdge(from: node, to: sink, value: 1)
                for other in internalNodes.lazy.filter({ $0 != node }) {
                    graph.insertEdge(from: node, to: other, value: 1)
                }
            }
        }
    }
}
