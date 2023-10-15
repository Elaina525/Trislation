//
//  DeeplTranslate.swift
//  TranslateApp
//
//  Created by Naruse on 7/10/2023.
//

import Foundation

/// A class for translating text using the DeepL Translation API.
class DeeplTranslateModel {
    // Translate text using the DeepL API
    /// Translate text using the DeepL API.
    ///
    /// - Parameters:
    ///   - text: The text to be translated.
    ///   - from: The source language.
    ///   - to: The target language.
    ///   - completion: A closure to handle the translation result or error.
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
            "target_lang": convertToShortLanguage(to),
        ]

        if from != "Auto" {
            request.addValue(convertToShortLanguage(from), forHTTPHeaderField: "source_lang")
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

    // Convert the full language name to its short form
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

/// A struct to represent the response from DeepL Translation API.
struct DeepLTranslation: Codable {
    let translations: [Translation]
}

/// A struct to represent a translation result.
struct Translation: Codable {
    let detected_source_language: String
    let text: String
}
