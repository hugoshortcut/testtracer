//
//  DetailView.swift
//  TopTest (iOS)
//
//  Created by Hugo Diaz on 2022-06-28.
//

import SwiftUI

@MainActor
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
            .assign(to: &$gifAddress)

        welcomePublisher
            .map { $0.data.first?.title ?? "Error Getting Gif Title" }
            .replaceError(with: "")
            .assign(to: &$gifTitle)
    }
}

struct DetailView: View {
    @EnvironmentObject var authViewModel: AuthorizeViewModel

    @StateObject var detailViewModel: DetailViewModel = DetailViewModel()

    var body: some View {
        VStack {
            Text("Welcome **\(authViewModel.username)**!")

            VStack {
                Text("\(detailViewModel.gifTitle)")
                    .padding(.top)

                // swiftlint:disable:next line_length
                AsyncImage(url: URL(string: detailViewModel.gifAddress), transaction: .init(animation: .spring(response: 1.7))) { phase in
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
        .onAppear { detailViewModel.fetchSpecificJSON() }
        .padding()
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
