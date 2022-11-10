//
//  String+.swift
//  SampleAPI
//
//  Created by Johnny Toda on 2022/08/07.
//

import Foundation

// ひらがな入力をカタカナ入力に変換
extension String {
    func hiraganaToKatakana() -> String {
        self.transform(transform: .hiraganaToKatakana, reverse: false)
    }

    private func transform(transform: StringTransform, reverse: Bool) -> String {
        if let string = applyingTransform(transform, reverse: reverse) {
            return string
        } else {
            return ""
        }
    }
}
