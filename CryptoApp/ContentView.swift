//
//  ContentView.swift
//  CryptoApp
//
//  Created by Андрей Груненков on 03.05.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home().preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
