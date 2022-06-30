//
//  Detail.swift
//  TopTest (iOS)
//
//  Created by Hugo Diaz on 2022-06-30.
//

import SwiftUI

class DetailViewModel: ObservableObject {
    @Published var gifAddress: String = ""
    @Published var gifTitle: String = ""

    func fetchSpecificJSON() {
        let whereLiveGifsAre = URL(string: current.realLiveJSONQueryLink)!

        let welcomePublisher = URLSession.shared.dataTaskPublisher(for: whereLiveGifsAre)
            .map(\.data)
            .decode(type: Welcome.self, decoder: JSONDecoder())

        welcomePublisher
            .map { $0.data.first?.images.original.url ?? "" }
            .replaceError(with: "Error Getting Gif Address")
            .receive(on: RunLoop.main)
            .assign(to: &$gifAddress)

        welcomePublisher
            .map { $0.data.first?.title ?? "Error Getting Gif Title" }
            .replaceError(with: "")
            .receive(on: RunLoop.main)
            .assign(to: &$gifTitle)
    }
}
