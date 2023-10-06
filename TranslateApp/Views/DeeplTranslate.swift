//
//  DeeplTranslate.swift
//  TranslateApp
//
//  Created by Naruse on 7/10/2023.
//

import SwiftUI

    func deeplTranslate(text: String, from: String, to: String, completion: @escaping (String?, Error?) -> Void) {
        let authKey = "fa3a4185-93ae-75b4-e19b-3d0181aba823:fx"
        let url = URL(string: "https://api-free.deepl.com/v2/translate")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("DeepL-Auth-Key \(authKey)", forHTTPHeaderField: "Authorization")
        request.addValue("YourApp/1.2.3", forHTTPHeaderField: "User-Agent")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody: [String: Any] = [
            "text": [text],
            "target_lang": to,
        ]

        if from != "auto" {
            request.addValue(from, forHTTPHeaderField: "source_lang")
        }

        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let decodedData = try JSONDecoder().decode(DeepLTranslation.self, from: data)
                DispatchQueue.main.async {
                    let deeplTranslatedText = decodedData.translations.first?.text ?? ""
                    completion(deeplTranslatedText, nil)
                }
            } catch {
                completion(nil, error)
            }
        }.resume()
    }



    // for deepl

struct DeepLTranslation: Codable {
    let translations: [Translation]
}

struct Translation: Codable {
    let detected_source_language: String
    let text: String
}