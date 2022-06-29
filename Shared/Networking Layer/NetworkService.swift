//
//  NetworkService.swift
//  TopTest (iOS)
//
//  Created by Hugo Diaz on 2022-06-28.
//

import SwiftUI

// MARK: - NetworkService
class NetworkService {

    @MainActor
    // Not using this now because I am not parsing the address from the JSON as I normally
    // would with more time to see the structure for search results from giphy.
    func fetchSpecificGif() async throws -> Welcome? {
        let components = specifyURL(fromPieces: URLPieces.fetchTopgolferImageAddress)
        guard let validatedURL = components.url else { return nil }

        var urlRequest = URLRequest(url: validatedURL)
        urlRequest.httpMethod = URLPieces.fetchTopgolferImageAddress.method
        guard (urlRequest.url?.absoluteString) != nil else { return nil } // validURL
        // guard let validURL = urlRequest.url?.absoluteString else { return nil }
        // String above simplifies web fetch code, for now.

        var remoteJSON: Welcome
        do {
            remoteJSON = try await fetchGenericData(current.realLiveJSONQueryLink)  // (validURL)
            print("\(String(describing: remoteJSON.data.first?.embedURL))")
        } catch {
            let error = NSError(domain: "Could not fetch remote data into JSON.", code: 0, userInfo: nil)
            throw error
        }
        return remoteJSON
    }

    func specifyURL(fromPieces givenPieces: URLPieces) -> URLComponents {
        var components = URLComponents()
        components.scheme = givenPieces.scheme
        components.host = givenPieces.host
        components.path = givenPieces.pathBeforeFile + givenPieces.pathEndFile

        return components
    }

    // Generic Fetch Query for Data
    private func fetchGenericData<T: Codable>(_ queryURLString: String) async throws -> T {
        guard let sourceURL = URL(string: queryURLString) else {
            let error = NSError(domain: "URL invalid", code: 0, userInfo: nil)
            throw error
        }
        do {
            let (incomingData, webResponse) = try await URLSession.shared.data(from: sourceURL)
            guard let httpResponse = webResponse as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                debugPrintStatusCode(webResponse)
                let error = NSError(domain: current.webDataDownloadErrorMessage, code: 0, userInfo: nil)
                throw error
            }
            // debugPrintIncomingData(incomingData)
            return try JSONDecoder().decode(T.self, from: incomingData)
        } catch {
            debugPrintFetchError(error)
            // swiftlint:disable:next force_cast
            return "" as! T
        }
    }
}

// MARK: - Debugging Helpers
// Debugging helpers to print fetched JSON data or response status code.
private func debugPrintIncomingData(_ incomingData: Data) {
    print("\r\r" + String(data: incomingData, encoding: .utf8)!
            + "——————————————>>>DOWNLOADED", terminator: "\r")
}

private func debugPrintStatusCode(_ webResponse: URLResponse) {
    print((webResponse as? HTTPURLResponse)?.statusCode as Any,
          terminator: " <<<——— RESPONSE statusCode\r\r")
}

private func debugPrintFetchError(_ error: Error) {
    print(error, terminator: current.jsonErrorDecodingMessage)
}
