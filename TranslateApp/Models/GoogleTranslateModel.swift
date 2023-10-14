//
//  GoogleTranslate.swift
//  TranslateApp
//
//  Created by Naruse on 14/10/2023.
//

import Foundation

class GoogleTranslateModel {
    func googleTranslate(text: String, from: String, to: String, completion: @escaping (String?, Error?) -> Void) {
        let authKey = "AIzaSyDENfMZiBIBggzfp1WAi7ysnKpHfGeIbHk"
    let url = URL(string: "https://translation.googleapis.com/language/translate/v2")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(authKey, forHTTPHeaderField: "x-goog-api-key")
        request.addValue("YourApp/1.2.3", forHTTPHeaderField: "User-Agent")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")

        var requestBody: [String: Any] = [
            "q": text,
            "target": convertToShortLanguage(to),
        ]

        if from != "Auto" {
            requestBody["source"] = convertToShortLanguage(from)
            request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
        }






        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])

    URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data else {
            print("Error: Data was nil") // 新的错误提示
            completion(nil, error)
            return
        }
                let responseString = String(data: data, encoding: .utf8)
            print("Raw response: \(responseString ?? "No data")")

        do {
            let decodedData = try JSONDecoder().decode(GoogleTranslation.self, from: data)
            DispatchQueue.main.async {
                let googleTranslatedText = decodedData.data.translations.first?.translatedText ?? ""
                completion(googleTranslatedText, nil)
            }
        } catch {
            print("Error: \(error.localizedDescription)") // 新的错误提示
            completion(nil, error)
        }
    }.resume()
    }
    fileprivate func convertToShortLanguage(_ fullLanguage: String) -> String {
        let languages = ["English", "Spanish", "French", "German", "Chinese", "Japanese", "Russian", "Arabic"]
        let shortLanguages = ["en", "es", "fr", "de", "zh", "ja", "ru", "ar"]

        if fullLanguage == "Auto" {
            return "auto"
        }
        let index = languages.firstIndex(of: fullLanguage) ?? 0
        return shortLanguages[index]
    }
}

// for Google Translate
struct GoogleTranslation: Codable {
    let data: TranslationData
}

struct TranslationData: Codable {
    let translations: [GoogleTranslationItem]
}

struct GoogleTranslationItem: Codable {
    let translatedText: String
}
