//
//  ContentView.swift
//  UWAPI_Request_Demo
//
//  Created by Pranav Sukumar on 11/11/22.
//

import SwiftUI

struct UWAPIResponse: Hashable, Codable {
    let response: UWAPIMiddle
    let status: String
    
}

struct UWAPIMiddle: Hashable, Codable {
    let moves: [Move]
    let position: String
    let positionValue: String
    let remoteness: Int
}

struct Move: Hashable, Codable {
    let deltaRemoteness: Int
    let move: String
    let moveName: String
    let moveValue: String
    let position: String
    let positionValue: String
    let remoteness: Int
}

class ViewModel: ObservableObject {
    
    @Published var moves: UWAPIResponse = UWAPIResponse(response: UWAPIMiddle(moves: [Move(deltaRemoteness: 0, move: "", moveName: "", moveValue: "", position: "", positionValue: "", remoteness: 0)], position: "", positionValue: "", remoteness: 0), status: "")
    
    
    var urlToFetch: String
    init(url: String) {
        urlToFetch = url
    }
    func fetch(){
//        guard let url = URL(string: "https://api.sunrise-sunset.org/json?date=2021-01-01&lat=-70&lng=40&formatted=0") else {
//            return
//        }
//        guard let url = URL(string: "https://iosacademy.io/api/v1/courses/index.php") else {
//            return
//        }
        guard let url = URL(string:urlToFetch) else {
            return
        }
    
    
        let task = URLSession.shared.dataTask(with: url) {[weak self] data, _,
            error in
            guard let data = data, error == nil else {
                print("Bad thing")
                return
            }
            
            do {
                let moves = try JSONDecoder().decode(UWAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.moves = moves
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
}
struct ContentView: View {
    @StateObject var viewModel = ViewModel(url: "https://nyc.cs.berkeley.edu/universal/v1/games/ttt/variants/regular/positions/R_A_3_3_----x----/")
    var body: some View {
        NavigationView{
            
            VStack{
                Text("Possible moves from  " + viewModel.moves.response.position)
                List{
                    ForEach(viewModel.moves.response.moves, id:\.self) { move in
                        HStack {
                            Text("Move: " + move.move + " | Result: " + move.positionValue).bold()
                        }.padding(3)
                    }
                }
                .navigationTitle("UWAPI Data:")
                
            }.onAppear{
                viewModel.fetch()
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

