//
//  ContentView.swift
//  API List
//
//  Created by Dhanush Tipparaju on 2/21/23.
//

import SwiftUI

struct ContentView: View {
    @State private var categories = [String]()
    @State private var showingAlerts = false
    var body: some View {
        NavigationView {
            List(categories , id: \.self) { category in
                NavigationLink(destination: EntryView(category: category)) {
                    Text(category)
                }
            }
            .navigationTitle("API Catagories")
        }
        .task {
            await getCategories()
        }
        .alert(isPresented: $showingAlerts) {
            Alert(title: Text("Loading Error"),
                  message: Text("There was a problem loading the API categories"),
                  dismissButton: .default(Text("OK")))
        }
    }
    func getCategories() async {
        let query = "https://api.publicapis.org/categories"
        if let url = URL(string: query) {
            if let (data, _) = try? await URLSession.shared.data(from: url) {
                if let decodedResponse = try? JSONDecoder().decode(Categories.self, from: data) {
                    categories = decodedResponse.categories
                    return
                }
            }
        }
        showingAlerts = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Categories: Codable {
    var categories: [String]
}
