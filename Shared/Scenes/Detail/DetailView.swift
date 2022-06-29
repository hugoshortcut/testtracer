//
//  DetailView.swift
//  TopTest (iOS)
//
//  Created by Hugo Diaz on 2022-06-28.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var authViewModel: AuthorizeViewModel

    // Only need 1 gif displayed for this excercise.
    @State var justOneGifAddress: String = ""
    @State var justOneGifTitle: String = ""

    var body: some View {
        VStack {
            Text("Welcome **\(authViewModel.username)**!")

            VStack {
                Text("\(justOneGifTitle)")
                    .padding(.top)

                // swiftlint:disable:next line_length
                AsyncImage(url: URL(string: current.realLiveGifLink), transaction: .init(animation: .spring(response: 1.7))) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .progressViewStyle(.circular)
                    case .success(let loadedGif):
                        loadedGif
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        Text("Failed fetching image.")
                            .foregroundColor(.red)
                    @unknown default:
                        Text("Unknown error. Try again.")
                            .foregroundColor(.red)
                    }
                }
                .aspectRatio(contentMode: .fit)
                .cornerRadius(20)
            }

            logoutButton(authViewModel)
        }
        .onAppear(perform: fetchSpecificJSON)
        .padding()
    }

    func fetchSpecificJSON() {
        let whereLiveGifsAre = URL(string: current.realLiveJSONQueryLink)!

        let gifsJSON = URLSession.shared.dataTask(with: whereLiveGifsAre) {(data, _, _) in
            guard let data = data else {
                print("Invalid Web Response")
                return
            }
            // JSON loaded… print(String(data: data, encoding: .utf8)!)
            if let giphyGroup = try? JSONDecoder().decode(Welcome.self, from: data) {
                _ = giphyGroup.data.map {
                    justOneGifAddress = $0.embedURL
                    justOneGifTitle = $0.title
                }
            } else {
                print(current.jsonErrorDecodingMessage)
            }
        }

        gifsJSON.resume()
    }
}

func logoutButton(_ authViewModel: AuthorizeViewModel) -> some View {
    return Button("Log Out", action: authViewModel.logOut)
        .tint(.red)
        .buttonStyle(.bordered)
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
            .environmentObject(AuthorizeViewModel())
    }
}
