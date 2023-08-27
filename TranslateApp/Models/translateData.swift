//
//  translateData.swift
//  TranslateApp
//
//  Created by Naruse Shiroha on 27/8/2023.
//

import SwiftUI

struct TranslateData: Codable, Identifiable {
    var id = UUID()
    var originalText: String
    // translatedText like ["Deepl": "translated text", "Google": "translated text", "Bing": "translated text"]
    var translatedText: [String: String]
    var isFavourite: Bool
    var source: String
    var target: String
    var date: Date
}

class ReadData: ObservableObject {
    @Published var translateData: [TranslateData] = [TranslateData]()

    init() {
        loadData()
    }

    // Can the json file be read from any location inside the project directory?
    func loadData() {
        // see how file in the project is read
        guard let url = Bundle.main.url(forResource: "TranslateData", withExtension: "json") else {
            print("Json file not found")
            return
        }

        let data = try? Data(contentsOf: url)
        // this is for reading, can you think of what can be used for writing into the file?
        let translateData = try? JSONDecoder().decode([TranslateData].self, from: data!)
        self.translateData = translateData!
    }
}
