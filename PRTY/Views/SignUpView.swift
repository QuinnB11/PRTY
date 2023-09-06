//
//  SignUpView.swift
//  PRTY
//
//  Created by Quinn Butcher on 12/1/22.
//

import SwiftUI
import FirebaseAuth
import RealmSwift
import Firebase

struct SignUpView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    let app = App(id: "application-prty-vtmer")

    var body: some View {
        
        ZStack {
            VStack(spacing: 16) {
                TextField("First Name", text: $firstName)
                    .textFieldStyle(SignUpTextFieldStyle())
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(SignUpTextFieldStyle())
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(SignUpTextFieldStyle())
                SecureField("Password", text: $password)
                    .textFieldStyle(SignUpTextFieldStyle())
                Button(action: {
                    signUpUser()
                                        
                }, label: {
                    Text("Create Account")
                        .foregroundColor(.white)
                }).frame(width: 280, height: 45, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
    }
    
    func signUpUser() -> Error? {
            var firebaseError: Error?
            let email = self.email // get email from the view model
            let password = self.password // get password from the view model
            Auth.auth().createUser(withEmail: email, password: password) { user, error in
                if error == nil { // no error -> proceed with user sign in
                    print("Creation of Firebase user successful.")
                    // this is the right time to e.g. send a welcome email to the user
                    _ = self.signInUserViaEmail() // recommend to continue with a sign-in of the user
                } else { // in case of error
                    firebaseError = error
                }
            }
            return firebaseError
        }
    
    func signInUserViaEmail() -> Error? {
            var firebaseError: Error?
            let email = self.email
            let password = self.password
            Auth.auth().signIn(withEmail: email, password: password) { user, error in // try Firebase sign-in
                if error == nil { // no error during Firebase sign in occurred
                    print("Firebase sign in successful with e-mail.")
                    initiateSynchronizationWithRealm() { (success,error) in // now try to connect to Realm
                        if error == nil { // option 1: Firebase and Realm sign in both were successful
                            DispatchQueue.main.async {
                                // do whatever you want once the sign in was successful
                            }
                        } else { // option 2: an error occured signing in to Realm
                            DispatchQueue.main.async {
                                print(error?.localizedDescription)
                                // do whatever you want in case an error occurred (suggest to sign-out from Firebase)
                            }
                        }
                    }
                } else { // option 3: in case of error during firebase authentication
                    firebaseError = error
                        // do whatever you want in case the sign-in to Firebase failed
                }
            }
            return firebaseError
        }
    func initiateSynchronizationWithRealm(completionHandler: @escaping (Bool?, Swift.Error?) -> Void) {
        self.loadSyncedUserRealm() { (success,error) in
            if error != nil { // something went wrong when trying to connect to Realm
                completionHandler(false,error)
            } else { // everything is fine, connection to Realm established
                completionHandler(true,nil)
            }
        }
    }

    func loadSyncedUserRealm(completionHandler: @escaping (Bool?, Swift.Error?) -> Void) {
            getSyncUser() { (realmUser,error) in // first, try to retrieve a Realm sync user
                if error != nil { // sync user could not be retrieved
                    print("Realm user could not be retrieved: (\(String(describing: error)))\n")
                    completionHandler(false,error)
                } else { // a Realm sync user could be retrieved
                    print("Received a Realm user: \(String(describing: realmUser?.id))")
                    guard let realmUser = realmUser else { return }
                    let realmUserId = realmUser.id
                    // in the next line, you probably want to construct your partition string based on the user id
                    let config = realmUser.configuration(partitionValue: "put-your-partition-string-here")
                    Realm.asyncOpen(configuration: config) { [self](result) in
                        switch result {
                        case .failure(let error): // not able to open the Realm
                            print("Not able to open user's private sync Realm: (\(error))\n")
                            print(error.localizedDescription)
                            completionHandler(false,error)
                        case .success(let userRealm): // able to open the Realm
                            print("Successfully opened user's private synced Realm (\(String(describing: realmUserId)))")
                            completionHandler(true,nil)
                        }
                    }
                }
            }
        }

    private func getSyncUser(completionHandler: @escaping (RealmSwift.User?, Swift.Error?) -> Void) {
            Auth.auth().currentUser?.getIDToken(){ (idToken, error) in // retrieve the token directly from the Firebase user
                if error == nil, let token = idToken {
                    let credentials = Credentials.jwt(token: token) // create the credentials for Realm based on the token
                    self.app.login(credentials: credentials, { (result) in
                        switch result {
                        case .failure(let error): // something went wrong
                            print("Login failed: \(error.localizedDescription)")
                            completionHandler(nil,error)
                        case .success(let user): // login to MongoDB Realm was successful
                            print("Successfully logged in as user \(user)")
                            let user = self.app.currentUser
                            completionHandler(user,nil)
                        }
                    })
                }else{
                    print("Error receiving Firebase token")
                    completionHandler(nil,error)
                }
            }
        }

}





struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
