//
//  AuthView.swift
//  PRTY
//
//  Created by Quinn Butcher on 4/1/23.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject private var authModel: AuthViewModel

    var body: some View {
        Group {
        if authModel.user != nil {
        UserProfileView()
        } else {
        RootView()
        }
        }.onAppear {
        authModel.listenToAuthState()
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView().environmentObject(AuthViewModel())
    }
}
