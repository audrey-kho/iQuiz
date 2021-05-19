//
//  QuizView.swift
//  iQuiz
//
//  Created by stlp on 5/13/21.
//

import SwiftUI

struct QuizView: View {
    let items: [QuizItem]
    @State var qNum: Int = 0
    @State var scene: String = "question"
    @State var click: Int = -1
    @State var score: Int = 0
    
    var body: some View {
        let current = items[qNum]
        if (scene == "question") {
            VStack {
                Text(current.text).padding(30)
                VStack {
                    ForEach((0..<current.answers.count), id: \.self) { q in
                        genButton(i: q)
                    }
                }
            }
            Spacer()
            HStack {
                Spacer()
                if (click > -1) {
                    Button(action: {
                        scene = "answer"
                        if (click == current.answer) {
                            score += 1
                        }
                    }, label: {
                        Text("Submit")
                    }).padding(20)
                }
            }
        } else if (scene == "answer") {
            VStack {
                Text(current.text).padding(30)
                VStack {
                    ForEach((0..<current.answers.count), id: \.self) { q in
                        genButton(i: q)
                    }
                }
                Spacer()
                if (click != current.answer) {
                    Text("Wrong!").font(.title3).foregroundColor(.red)
                    Text("The correct answer is \(current.answers[current.answer])").font(.subheadline)
                } else {
                    Text("Correct!").font(.title3).foregroundColor(.green)
                }
                Spacer()
            }
            Spacer()
            HStack {
                Spacer()
                if (qNum < items.count - 1) {
                    Button(action: {
                        scene = "question"
                        click = -1
                        qNum += 1
                    }, label: {
                        Text("Next")
                    }).padding(20)
                } else {
                    Button(action: {
                        scene = "finished"
                    }, label: {
                        Text("Finish")
                    }).padding(20)
                }
            }
        } else if (scene == "finished") {
            let pct:Double = Double(score) / Double(items.count) * 100
            Spacer()
            VStack (spacing: 30) {
                if (pct == 100) {
                    Text("Perfect score!").font(.title).fontWeight(.bold).foregroundColor(.green)
                } else if (pct >= 65) {
                    Text("Almost!").font(.title).fontWeight(.bold).foregroundColor(.blue)
                } else {
                    Text("You failed!").font(.title).fontWeight(.bold).foregroundColor(.red)
                }
                Text("\(score) out of \(items.count) correct")
            }
            Spacer()
        } else {
            Text("Error!").foregroundColor(.red)
        }
    }
    
    func genButton(i : Int) -> some View {
        let current = items[qNum]
        var color : Color

        if (scene == "question") {
            if (click == i) {
                color = .blue
            } else {
                color = .secondary
            }
        } else if (scene == "answer") {
            if (i == current.answer && click == i) {
                // correct ans
                color = .green
            } else if (click == i) {
                color = .red
            } else {
                color = .secondary
            }
        } else {
            color = .gray
        }
        return
            Button(action: {
                if (scene == "question") {
                    click = i
                }
            }, label: {
                Text(verbatim: current.answers[i])
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50, alignment: .center)
            })
            .disabled(scene != "question")
            .background(color)
            .cornerRadius(5)
    }
}
