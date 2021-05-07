//
//  ContentView.swift
//  iQuiz
//
//  Created by stlp on 5/5/21.
//

import SwiftUI

struct ContentView: View {
    @State var showingAlert: Bool = false
    @ObservedObject var categories: QuizList = QuizList()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories.quizzes, id: \.self) { quiz in
                    HStack (spacing: 20) {
                        Image(systemName: quiz.icon)
                        
                        VStack (alignment: .leading, spacing: 5) {
                            Text(quiz.name).font(.title2).fontWeight(.semibold)
                            Text(quiz.desc).lineLimit(1)
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
            Alert(title: Text("Settings"), message: Text("Settings go here"), dismissButton: .default(Text("Okay")))
        }).navigationViewStyle(StackNavigationViewStyle())
    }
}

class Quiz: NSObject {
    var name: String
    var desc: String
    var icon: String
    
    init(name: String, desc: String, icon: String) {
        self.name = name
        self.desc = desc
        self.icon = icon
    }
}

class QuizList: ObservableObject {
    @Published var quizzes: [Quiz] = []
    
    init() {
        quizzes = [
            Quiz(name: "Mathematics", desc: "Put your problem solving skills to the test", icon: "x.squareroot"),
            Quiz(name: "Marvel Superheroes", desc: "How well do you know the heroes of the MCU?", icon: "burst"),
            Quiz(name: "Science", desc: "Test your knowledge on scientific facts and principles", icon: "lightbulb")
        ]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
