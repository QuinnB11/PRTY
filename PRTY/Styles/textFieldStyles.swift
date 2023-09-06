//
//  textFieldStyles.swift
//  PRTY
//
//  Created by Quinn Butcher on 6/30/23.
//

import Foundation
import SwiftUI



struct SignUpTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .disableAutocorrection(true)
            .autocapitalization(.none)
            .frame(width: 280, height: 45, alignment: .center)
            .cornerRadius(20)
            .shadow(color: .gray, radius: 10)
    }
}

