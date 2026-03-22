//
//  ContentView.swift
//  EmojiCounter
//
//  Created by user296300 on 3/22/26.
//

import SwiftUI

struct EmojiItem: Identifiable {
    let id = UUID()
    let emoji: String
    var count: Int
}

struct ContentView: View {
    @State private var emojiItems: [EmojiItem] = [
        EmojiItem(emoji: "🐅", count: 0),
        EmojiItem(emoji: "🦅", count: 0),
        EmojiItem(emoji: "✌️", count: 0),
        EmojiItem(emoji: "🔥", count: 0),
        EmojiItem(emoji: "🥸", count: 0)
    ]

    var body: some View {
    
            NavigationStack {
                
                List {
                    ForEach($emojiItems) { $item in
                        HStack {
                            Text(item.emoji)
                                .font(.largeTitle)

                            Spacer()

                            Button("-") {
                                
                                    item.count -= 1
        
                            }
                            .buttonStyle(.bordered)

                            Text("\(item.count)")
                                .frame(minWidth: 40)

                            Button("+") {
                                item.count += 1
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(.vertical, 6)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Emoji Counter")
                            .font(.largeTitle)
                    }
                }
            
            }
       
        
             }
}

#Preview {
    ContentView()
}

