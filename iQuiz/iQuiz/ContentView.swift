//
//  ContentView.swift
//  iQuiz
//
//  Created by stlp on 5/5/21.
//

import SwiftUI
import Network

struct ContentView: View {
    @State var showingAlert: Bool = false
    @State private var networkAlert = false
    @State private var downloadAlert = false
    @State var categories = [Quiz]()
    @State var jsonUrl = "http://tednewardsandbox.site44.com/questions.json"
    // https://www.hackingwithswift.com/example-code/networking/how-to-check-for-internet-connectivity-using-nwpathmonitor
    let monitor = NWPathMonitor()
    
    init() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("We're connected!")
            } else {
                print("No connection.")
            }
        }
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
    }
    
    // https://www.hackingwithswift.com/forums/swiftui/decoding-json-data/3024
    func loadData() {
        if (monitor.currentPath.status != .satisfied) {
            networkAlert = true
            return
        }
        
        guard let url = URL(string: self.jsonUrl) else {
            self.downloadAlert = true
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                if let data = data {
                    let decodedData = try JSONDecoder().decode([Quiz].self, from: data)
                    DispatchQueue.main.async {
                        self.categories = decodedData
                        self.downloadAlert = false
                        print(self.categories)
                    }
                } else {
                    self.downloadAlert = true
                }
                
            } catch {
                print("Fetch failed: \(error.localizedDescription )")
            }
        }.resume()
    }
    
    var body: some View {
        NavigationView {
            List (categories) { quiz in
                NavigationLink(
                    destination: VStack {
                        HStack {
                            Text(quiz.title).font(.largeTitle).fontWeight(.semibold)
                            Spacer()
                        }
                        // quiz content
                        QuizView(items: quiz.questions)
                    }.padding(.horizontal, 20),
                    label: {
                        HStack (spacing: 20) {
                            Image(systemName: "doc.text")
                            
                            VStack (alignment: .leading, spacing: 5) {
                                Text(quiz.title).font(.title2).fontWeight(.semibold)
                                Text(quiz.desc).lineLimit(1)
                            }
                        }.padding(.vertical, 10)
                    }
                )
            }.onAppear(perform: loadData)
            .padding(.top, 5)
            .navigationTitle("iQuiz")
            .toolbar(content: {
                ToolbarItem {
                    Button(action: {
                        self.showingAlert = true
                    }, label: {
                        Text("Settings")
                    })
                    .popover(isPresented: $showingAlert) {
                        VStack {
                            Text("Settings")
                                .font(.headline)
                                .padding(.vertical)
                            Spacer()
                            VStack {
                                Text("Link to JSON file").padding(10)
                                TextField("http://tednewardsandbox.site44.com/questions.json", text: $jsonUrl)
                                    .padding(10)
                                    .border(Color.gray)
                                    .cornerRadius(8)
                            }.padding(20)
                            .alert(isPresented: $networkAlert) {
                                Alert(title: Text("Network Unavailable"), message: Text("Unable to establish a network connection"), dismissButton: .default(Text("Okay")))
                            }
                            Button(action: {
                                self.loadData()
                                self.showingAlert = false
                            }, label: {
                                Text("Check now")
                                    .padding(30)
                            }).alert(isPresented: $downloadAlert) {
                                Alert(title: Text("Unable to Download"), message: Text("Check again later"), dismissButton: .default(Text("Okay")))
                            }
                            Spacer()
                        }
                    }
                }
            })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Quiz: Identifiable, Decodable {
    var id:String {title}
    var title: String = ""
    var desc: String = ""
    var questions: [QuizItem] = []
    
    private enum CodingKeys: String, CodingKey {
        case title, desc, questions
    }
}

struct QuizItem: Identifiable, Decodable {
    var id: String {text}
    var text: String = ""
    var answers: [String] = []
    var answer: String = ""
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
