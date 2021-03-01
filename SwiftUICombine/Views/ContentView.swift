//
//  ContentView.swift
//  SwiftUICombine
//
//  Created by David U. Okonkwo on 3/1/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    var body: some View {
        ScrollView {
            Button(action: {
                viewModel.startFetch()
            }, label: {
                Text("Start")
            })
            
            Text(viewModel.time)
            Text(viewModel.seconds)
                .foregroundColor(.red)
            Text("\(viewModel.timeModel.seconds) s")
                .foregroundColor(.blue)
            
            Text("Hello, world!1")
            Text("Hello, world!2")
            Text("Hello, world!3")

                
        }.padding()
        .font(.system(size: 36, weight: .bold))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
