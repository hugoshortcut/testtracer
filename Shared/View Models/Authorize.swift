//
//  Authorize.swift
//  TopTest (iOS)
//
//  Created by Hugo Diaz on 2022-06-28.
//

import SwiftUI
import Combine

class AuthorizeViewModel: ObservableObject {
    @AppStorage("AUTH_KEY") var authenticated = false {
        willSet { objectWillChange.send() }
    }

    // Remove quoted password and username for real-world app, leave empty instead…
    @AppStorage("USER_KEY") var storedUsername = ""
    @Published var username: String = "launchname"  // Quick test value filled at launch.
    @Published var password = "password"
    // These two above are simply for ease in prototyping.

    @Published var invalid: Bool = false

    @Published var readyToGo: Bool = false

    private var cancellables: Set<AnyCancellable> = []

    func toggleAuthentication() {
        self.password = ""
        withAnimation {
            authenticated.toggle()
        }
    }

    func authenticate() {
        // Only doing != on empty, because requirement wants any username to work. Otherwise "==" sample.
        guard self.username.lowercased() != current.sampleUser,
              self.password.lowercased() == current.samplePassword else {
            self.invalid = true
            return
        }

        storedUsername = self.username.lowercased()
        toggleAuthentication()
    }

    func logOut() {
        password = ""
        storedUsername = ""
        username = "" // Erasing UI after logout, to force typing & accept username with anything again.

        withAnimation {
            authenticated = false
        }
    }

    func forgotPasswordButtonPress() {
        print("Button pressed. <action__not_yet_implemented>")
    }

    func handleLoginSecurity() {
        print("Security steps to take. <not_yet_implemented>")
    }

    private var passwordIsValidPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { passInput in
                !passInput.isEmpty
            }
            .eraseToAnyPublisher()
    }

    private var usernameIsValidPublisher: AnyPublisher<Bool, Never> {
        $username
            .map { usernameInput in
                !usernameInput.isEmpty
            }
            .eraseToAnyPublisher()
    }

    init() {
        print("Currently logged on: \(authenticated)\n" + "Current user: \(username)\n")

        usernameIsValidPublisher
            .combineLatest(passwordIsValidPublisher)
            .map { usernameInput, passInput in
                usernameInput && passInput
            }
            .map { bothFieldsValid -> Bool in
                return bothFieldsValid
            }
            .assign(to: \.readyToGo, on: self)
            .store(in: &cancellables)
    }
}
