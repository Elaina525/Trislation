//
//  CoreDataTest.swift
//  TranslateApp
//
//  Created by Naruse on 11/10/2023.
//

import CoreData
import SwiftUI
struct CoreDataTest: View {
    // 使用 @FetchRequest 从 CoreData 获取 TranslatedText 实体
    @FetchRequest(
        entity: TranslatedText.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TranslatedText.original_text, ascending: true)]
    ) var translatedTexts: FetchedResults<TranslatedText>

    var body: some View {
        
        List {
            ForEach(translatedTexts, id: \.self) { translatedText in
                Text(translatedText.original_text ?? "未知") // 替换 someAttribute 为你实际的属性
                // print all 
                // print(translatedText.original_text ?? "未知")
                // print(translatedText.source1 ?? "未知")
            }
        }
    }
}

struct CoreDataTest_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataTest()
    }
}
