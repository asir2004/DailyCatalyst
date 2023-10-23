//
//  EmojiFunc.swift
//  DailyCatalyst
//
//  Created by Asir Bygud on 10/18/23.
//

import Foundation

func emojiFromHappiness(happiness: Int) -> String {
    switch happiness {
    case 1: return "😐"
    case 2: return "🙂"
    case 3: return "😀"
    case 4: return "😁"
    case 5: return "😆"
    default: return "🥲"
    }
}
