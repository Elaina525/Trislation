//
//  GoogleTranslate.swift
//  TranslateApp
//
//  Created by Naruse on 14/10/2023.
//

import Foundation
/// A class for translating text using the Google Translation API.
class GoogleTranslateModel {
    /// Translate text using the Google Translation API.
    ///
    /// - Parameters:
    ///   - text: The text to be translated.
    ///   - from: The source language.
    ///   - to: The target language.
    ///   - completion: A closure to handle the translation result or error.
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
                print("Error: Data was nil") // New error message
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
                print("Error: \(error.localizedDescription)") // New error message
                completion(nil, error)
            }
        }.resume()
    }

    /// Convert the full language name to its short form.
    ///
    /// - Parameter fullLanguage: The full name of the language.
    /// - Returns: The short form of the language.
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

/// A struct to represent the response from Google Translation API.
struct GoogleTranslation: Codable {
    let data: TranslationData
}
/// A struct to represent translation data.
struct TranslationData: Codable {
    let translations: [GoogleTranslationItem]
}
/// A struct to represent a translation result.
struct GoogleTranslationItem: Codable {
    let translatedText: String
}
