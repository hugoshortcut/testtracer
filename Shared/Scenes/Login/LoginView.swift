//
//  LoginView.swift
//  TopTest (iOS)
//
//  Created by Hugo Diaz on 2022-06-28.
//

import SwiftUI
import Combine

enum FocusableField: Hashable {
    case username, password
}

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthorizeViewModel
    @EnvironmentObject var sceneDelegate: DefaultSceneDelegate

    @FocusState private var focus: FocusableField?

    let limitNameChars: Int = 30
    let limitPasswordChars: Int = 26

    var body: some View {
        if authViewModel.authenticated {
            DetailView()
        } else {
            ZStack {
                backGroundImage()
                VStack(alignment: .center, spacing: 17) {
                    Spacer()
                    VStack {
                        welcomeWave()
                            .padding(.horizontal)
                        HStack(alignment: .center) {
                            Spacer()
                            logInBanner()
                            Spacer()
                        }
                    }

                    Group {
                        usernameField()
                        passwordField()
                    }
                    .textFieldStyle(.roundedBorder)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .multilineTextAlignment(.center)

                    instructionsButton()
                        .cornerRadius(12)

                    HStack {
                        Spacer()
                        forgotPassButton()
                    }
                    Spacer()
                }
                .padding()
                .textFieldStyle(.plain)
                .frame(width: 300)
                .padding()

                .alert("Access Denied", isPresented: $authViewModel.invalid) {
                    Button {
                        focus = .username
                        authViewModel.forgotPasswordButtonPress()
                    } label: {
                        Text("Dismiss")
                    }
                }
            }
            .transition(.moveAndFade)
        }
    }

    fileprivate func forgotPassButton() -> some View {
        return Button("Forgot Password?", action: authViewModel.forgotPasswordButtonPress)
            .padding(.horizontal, 7.0)
            .background(Rectangle().fill(Color.blue.opacity(0.7)).blur(radius: 12))
            .tint(.red.opacity(0.77))
            .shadow(color: Color(red: 0.849, green: 0.849,
                                 blue: 0.87, opacity: 0.7), radius: 1, x: -3, y: -3)
            .shadow(color: Color(red: 0.749, green: 0.749,
                                 blue: 0.77, opacity: 0.7), radius: 2, x: 2, y: 2)
    }

    fileprivate func loginButton() -> some View {
        return Button(action: {
            authViewModel.authenticate()
        }, label: {
            Text("Log In")
                .bold()
                .padding()
                .foregroundColor(Color.blue)
        })
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 34, style: .continuous).fill(.white.opacity(0.7))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .strokeBorder(Color.blue, lineWidth: 4)
        )
    }

    fileprivate func welcomeWave() -> some View {
        return Label("Welcome back!", systemImage: "hand.wave.fill")
            .foregroundColor(.accentColor)
            .border(.clear)
            .shadow(color: .yellow, radius: 0.2, x: -1, y: -1)
            .shadow(color: .purple, radius: 0.3, x: 0, y: -1)
    }

    fileprivate func instructionsButton() -> some View {
        let ready: Bool = $authViewModel.readyToGo.wrappedValue
        return Button {
            if ready { authViewModel.authenticate() }
        } label: {
            if ready {
                Spacer()
                Image(systemName: "checkmark.circle")
                Text("  Login")
                Spacer()
            } else {
                Image(systemName: "exclamationmark.circle")
                Text("  Fill out both fields to login.")
            }
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, alignment: .center)
        .padding([.vertical], 8)
        .opacity(1)
        .background(ready ? .blue : .gray.opacity(0.7))
        .disabled(!ready)
    }

    fileprivate func usernameField() -> some View {
        return TextField("Enter Your Email", text: $authViewModel.username)
            .textContentType(.emailAddress)
            .keyboardType(.emailAddress)
            .submitLabel(.next)
            .focused($focus, equals: .username)
            .onSubmit {
                focus = .password
            }
            .onReceive(Just(authViewModel.username)) { _ in
                if authViewModel.username.count > limitNameChars {
                    authViewModel.username = String(authViewModel.username.prefix(limitNameChars))
                }
            }
    }

    fileprivate func passwordField() -> some View {
        return SecureField("Enter Your Password", text: $authViewModel.password)
            .privacySensitive()
            .textContentType(.password)
            .keyboardType(.default)
            .submitLabel(.go)
            .focused($focus, equals: .password)
            .onSubmit {
                authViewModel.authenticate()
            }
            .onReceive(Just($authViewModel.password)) { _ in
                if authViewModel.password.count > limitPasswordChars {
                    authViewModel.password = String(authViewModel.password.prefix(limitPasswordChars))
                }
            }
    }
}

private func logInBanner() -> some View {
    return Text("Log In")
        .foregroundStyle(LinearGradient(colors: current.rainbow(),
                                        startPoint: .leading, endPoint: .trailing))
        .font(.system(size: 61, weight: .medium, design: .rounded))
        .shadow(color: Color(red: 0.051, green: 0.051,
                             blue: 0.03, opacity: 0.4), radius: 4, x: -7, y: -7)
        .shadow(color: Color(red: 0.051, green: 0.051,
                             blue: 0.03, opacity: 0.4), radius: 4, x: 6, y: 6)
}

private func backGroundImage() -> some View {
    return Image("stockholmWater")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .cornerRadius(20)
        .ignoresSafeArea()
}

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .offset(x: 0, y: UIScreen.main.bounds.size.height).combined(with: .scale),
            removal: .move(edge: .top)
        )
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthorizeViewModel())
    }
}
