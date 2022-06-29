//
//  URLPieces.swift
//  TopTest (iOS)
//
//  Created by Hugo Diaz on 2022-06-28.
//

import SwiftUI

/*
 Group of Topgolfer User JSON info exercise URLs…
 Our Giphy key…
 6RHSbiXgC4foK6TeqQJ6oJFaW8pa6bsJ

 "Few results JSON with search for 'swift' word query, to have small sample data":
 "https://api.giphy.com/v1/gifs/search?api_key=6RHSbiXgC4foK6TeqQJ6oJFaW8pa6bsJ&q=swiftui"

 "Embed" key has URL which is short & simple within JSON data.
 https://giphy.com/embed/Z6nwvyioy2DvEnzm1U
 */

// One URL can have: scheme, subdomain, domain name,
// top level domain, port, path, query, parameters, fragment

enum URLPieces {
    case fetchTopgolferImageAddress  // Made with 'cases' so we can add other URL variations later.

    var scheme: String {
        switch self {
        case .fetchTopgolferImageAddress:
            return "https"
        }
    }

    var host: String {
        switch self {
        case .fetchTopgolferImageAddress:
            return "giphy.com"
        }
    }

    var path: String { pathBeforeFile + pathEndFile }

    var pathBeforeFile: String {
        switch self {
        case .fetchTopgolferImageAddress:
            return "/embed/"
        }
    }

    var pathEndFile: String {
        switch self {
        case .fetchTopgolferImageAddress:
            return ""
        }
    }

    var parameters: [URLQueryItem] {
        switch self {
        case .fetchTopgolferImageAddress:
            return []
        }
    }

    var method: String {
        switch self {
        case .fetchTopgolferImageAddress:
            return "GET"
        }
    }
}
