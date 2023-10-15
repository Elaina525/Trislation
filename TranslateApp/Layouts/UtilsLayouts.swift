//
//  UtilsLayouts.swift
//  TranslateApp
//
//  Created by Xiaolong Guo on 23/8/2023.
//

import CoreData
import SwiftUI

/// A SwiftUI view for layout utility.
struct UtilsLayouts: View {
    var body: some View {
        // This is the main view for layout utilities

        CustomVerticalLayout {
            // You can place other views here
            // TranslateTextRow(data: TranslatedText())
        }
    }
}

struct UtilsLayouts_Previews: PreviewProvider {
    static var previews: some View {
        UtilsLayouts()
    }
}

/// A container for translations, displaying original and translated text.
struct TranslateTextRow: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @ObservedObject var data: TranslatedText

    var body: some View {
        Spacer()

        // A rounded rectangle with some styling
        RoundedRectangle(cornerRadius: 20)
            .stroke(style: StrokeStyle(lineWidth: 2))
            .frame(width: 350, height: 100)
            .foregroundColor(.black)
            .overlay {
                VStack(spacing: 10) {
                    HStack {
                        // Display the original text
                        Text(data.original_text ?? "未知")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Spacer()

                        // Display a star icon to toggle "favorite" status
                        Image(systemName: data.favourite ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .onTapGesture {
                                data.favourite.toggle()
                                do {
                                    try self.managedObjectContext.save() // Save changes to Core Data
                                } catch {
                                    // Handle save errors
                                    print(error.localizedDescription)
                                }
                            }
                    }

                    Divider()
                        .background(Color.gray)
                        .frame(height: 1)

                    // Display the translated text
                    Text(data.translated_text1 ?? "未知")
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
            }
            .padding(.horizontal, 40)
    }
}

/// A custom vertical layout for arranging subviews.
struct CustomVerticalLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) -> CGSize {
        var size = CGSize.zero
        for subview in subviews {
            let subviewSize = subview.sizeThatFits(proposal)
            size.width = max(size.width, subviewSize.width)
            size.height += subviewSize.height
        }
        size.height += CGFloat(subviews.count - 1) * 1.0 // Add spacing between subviews
        return size
    }

    func placeSubviews(in _: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache _: inout ()) {
        var yPosition: CGFloat = 0.0
        for (index, subview) in subviews.enumerated() {
            let subviewSize = subview.sizeThatFits(proposal)
            let subviewFrame = CGRect(x: 0, y: yPosition, width: subviewSize.width, height: subviewSize.height)
            subview.place(at: subviewFrame.origin, anchor: .topLeading, proposal: .unspecified)
            yPosition += subviewSize.height + 5.0 // Add spacing between subviews
        }
    }
}
