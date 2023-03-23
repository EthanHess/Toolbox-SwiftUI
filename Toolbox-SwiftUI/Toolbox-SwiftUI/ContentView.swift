//
//  ContentView.swift
//  Toolbox-SwiftUI
//
//  Created by Ethan Hess on 2/21/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ZStack {
                RadialGradient(gradient: Gradient(colors: [.blue, .white]), center: .center, startRadius: 2, endRadius: 650)
                CustomSlider()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
