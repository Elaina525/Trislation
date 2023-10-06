//
//  AzureTranslate.swift
//  TranslateApp
//
//  Created by Naruse on 7/10/2023.
//

import Foundation

    func azureTranslate(text: String, completion: @escaping (String?, Error?) -> Void) {
        let key = "48ccaa82136d4a59a6f58d9291149911"
        let region = "australiaeast"
        let endpoint = "https://api.cognitive.microsofttranslator.com"

        let url = URL(string: "\(endpoint)/translate?api-version=3.0&from=en&to=de")! // 这里将目标语言设为了德语（de）

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(key, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue(region, forHTTPHeaderField: "Ocp-Apim-Subscription-Region")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UUID().uuidString, forHTTPHeaderField: "X-ClientTraceId")

        let requestBody: [Any] = [["text": text]]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let decodedData = try JSONDecoder().decode([AzureTranslation].self, from: data)
                DispatchQueue.main.async {
                    let azureTranslatedText = decodedData.first?.translations.first?.text ?? ""
                    completion(azureTranslatedText, nil)
                }
            } catch {
                completion(nil, error)
            }
        }.resume()
    }


// for microsoft azure 
struct AzureTranslation: Codable {
    let translations: [AzureTranslationText]
}

struct AzureTranslationText: Codable {
    let text: String
}