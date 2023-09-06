//
//  StartView.swift
//  PRTY
//
//  Created by Quinn Butcher on 6/11/23.
//

import SwiftUI

struct StartView: View {
    
    let backgroundGradient = LinearGradient(gradient: Gradient(colors: [.red, .orange]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    var body: some View {
        NavigationStack {
            ZStack() {
                VStack(alignment: .leading) {
                    Text("PRTY")
                        .font(.system(size: 70, weight: .heavy, design: .default))

                }.frame(maxHeight: .infinity, alignment: .top)
                VStack {
                    NavigationLink {
                        SignUpView()
                    } label: {
                        SignUpButtonContent()
                    }
                    Text("OR")
                        .offset(y:10)
                        .font(.system(size: 20, weight: .heavy, design: .serif))
                    Text("Sign UP with Placeholder")
                }.frame(maxHeight: 20, alignment: .center)
                VStack(spacing: 10) {
                    NavigationLink {
                        loginView()
                    } label: {
                        LoginInButtonContent()
                    }
                }.frame(maxHeight: .infinity, alignment: .bottom)
            }.background(backgroundGradient)
        }
    }
}
    


struct SignUpButtonContent : View {
    var body: some View {
        Text("Sign up")
            .font(.system(size: 30, weight: .heavy, design: .serif))
            .foregroundColor(.black)
            .frame(height: 60)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(.red)
    }
}

struct LoginInButtonContent : View {
    var body: some View {
        Text("Already Have an Account? Login")
            .font(.system(size: 20, weight: .heavy, design: .serif))
            .foregroundColor(.black)
            .frame(maxWidth: .infinity, alignment: .bottom)
            .frame(height: 100, alignment: .center)
    }
}




struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
