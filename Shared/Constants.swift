//
//  Constants.swift
//  TopTest (iOS)
//
//  Created by Hugo Diaz on 2022-06-28.
//

import SwiftUI

struct World {
    var initialViewTested = LoginView()
    var isSkippingInitialScene: Bool = false // Set to true to go to scene above from the start.

    var sampleUser = "" // "username" normally in testing but requirement wants any username to work OK for now.
    var samplePassword = "password"

    var ourGiphyKey = "6RHSbiXgC4foK6TeqQJ6oJFaW8pa6bsJ"

    var realLiveGifLink = "https://c.tenor.com/-SJFHGdMU58AAAAM/gigi-hadid-sassy.gif"
    // from Tenor https://tenor.com

    // swiftlint:disable:next line_length
    var realLiveJSONQueryLink = "https://api.giphy.com/v1/gifs/search?api_key=6RHSbiXgC4foK6TeqQJ6oJFaW8pa6bsJ&q=swiftui"
    // remoteGifJSON… Welcome(data: [Datum], pagination: Pagination, meta: Meta)

    // Colors for LinearGradient.
    func rainbow() -> [Color] {
        return [.red, .orange, .yellow, .mint, .purple, .pink,
                Color(red: 0.929, green: 0.507, blue: 0.929, opacity: 1.0)]
    }

    // Network Service
    let webDataDownloadErrorMessage: String = "\r—————— data download ERROR\r"
    let jsonErrorDecodingMessage: String = "\r—————— JSON Decoder ERROR\r"
}

var current = World()
