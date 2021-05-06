//
//  ContentView.swift
//  iQuiz
//
//  Created by stlp on 5/5/21.
//

import SwiftUI

struct ContentView: View {
    @State var showingAlert: Bool = false
    @State var categories: [String] = ["Mathematics", "Marvel Superheroes", "Science"]
    @State var dict: [String : [String]] = ["Mathematics": ["x.squareroot", "Put your problem solving skills to the test"], "Marvel Superheroes": ["burst", "How well do you know the heroes of the MCU?"], "Science": ["lightbulb", "Test your knowledge on scientific facts and principles"]]
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories, id: \.self) { cat in
                    HStack (spacing: 20) {
                        Image(systemName: dict[cat]![0])
                        VStack (alignment: .leading, spacing: 5) {
                            Text(cat).font(.title)
                            Text(dict[cat]![1]).lineLimit(1)
                        }
                    }.padding(.vertical, /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }
            }.padding(.top, 5)
                .navigationTitle("iQuiz")
                .toolbar(content: {
                    ToolbarItem {
                        Button(action: {
                            self.showingAlert = true
                        }, label: {
                            Text("Settings")
                        })
                    }
                })
        }.alert(isPresented: $showingAlert, content: {
            Alert(title: Text("Alert"), message: Text("Settings go here"), dismissButton: .default(Text("Okay")))
        }).navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
