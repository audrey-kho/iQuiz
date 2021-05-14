//
//  ContentView.swift
//  iQuiz
//
//  Created by stlp on 5/5/21.
//

import SwiftUI
import Foundation

struct ContentView: View {
    @State var showingAlert: Bool = false
    @ObservedObject var categories: QuizList = QuizList()

    var body: some View {
        NavigationView {
            List {
                ForEach(categories.quizzes, id: \.self) { quiz in
                    NavigationLink(
                        destination: VStack {
                            HStack {
                                Text(quiz.name).font(.largeTitle).fontWeight(.semibold)
                                Spacer()
                            }
                            // quiz content
                            QuizView(items: quiz.items)
                        }.padding(20),
                        label: {
                            HStack (spacing: 20) {
                                Image(systemName: quiz.icon)
                                
                                VStack (alignment: .leading, spacing: 5) {
                                    Text(quiz.name).font(.title2).fontWeight(.semibold)
                                    Text(quiz.desc).lineLimit(1)
                                }
                            }.padding(.vertical, 10)
                        })
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
    var items: [QuizItem]
    
    init(name: String, desc: String, icon: String, items: [QuizItem]) {
        self.name = name
        self.desc = desc
        self.icon = icon
        self.items = items
    }
}

class QuizItem: Identifiable {
    let id = UUID()
    var question: String
    var choices: [String]
    var answer: Int
    
    init(q: String, choices: [String], answer: Int) {
        self.question = q
        self.choices = choices
        self.answer = answer
    }
}

class QuizList: ObservableObject {
    @Published var quizzes: [Quiz] = []
    
    init() {
        quizzes = [
            Quiz(name: "Mathematics", desc: "Put your problem solving skills to the test", icon: "x.squareroot", items: [QuizItem(q: "What is the square root of 4?", choices: ["1", "2", "3", "4"], answer: 1)]),
            Quiz(name: "Marvel Superheroes", desc: "How well do you know the heroes of the MCU?", icon: "burst", items: [QuizItem(q: "Who is Thor's brother?", choices: ["Odin", "Vision", "Loki", "Groot"], answer: 2), QuizItem(q: "Which infinity stone does Doctor Strange have?", choices: ["Mind", "Space", "Reality", "Time"], answer: 3), QuizItem(q: "What color is the Hulk?", choices: ["Blue", "Purple", "Green", "Yellow"], answer: 2)]),
            Quiz(name: "Science", desc: "Test your knowledge on scientific facts and principles", icon: "lightbulb", items: [QuizItem(q: "What makes leaves green?", choices: ["cholorophyll", "bug poop", "oxygen", "the sun"], answer: 0)])
        ]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
