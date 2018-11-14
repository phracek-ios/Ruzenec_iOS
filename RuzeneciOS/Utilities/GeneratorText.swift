//
//  GeneratorText.swift
//  RuzeneciOS
//
//  Created by Petr "Stone" Hracek on 14/11/2018.
//  Copyright © 2018 Petr Hracek. All rights reserved.
//

import Foundation
import UIKit
import BonMot

func generateContent(text: String) -> NSAttributedString {
    
    let baseStyle = StringStyle(
        .font(UIFont.systemFont(ofSize: 16)),
        .lineHeightMultiple(1),
        .alignment(.center)
    )
    
    let emphasized = baseStyle.byAdding(
        .font(UIFont.italicSystemFont(ofSize: 16))
    )

    let paragraph = baseStyle.byAdding(
        .paragraphSpacingBefore(20)
    )
    
    let redStyle = StringStyle(
        .color(.red)
    )
    
    let rules: [XMLStyleRule] = [
        .style("em", emphasized),
        .style("p", paragraph),
        .style("br", paragraph),
        .style("red", redStyle)
    ]
    
    let content = baseStyle.byAdding(
        .color(UIColor.darkGray),
        .xmlRules(rules)
    )
    var generated_text = text
    generated_text = generated_text.replacingOccurrences(of: "<p>\n", with: "<p>")
    generated_text = generated_text.replacingOccurrences(of: "\n</p>", with: "</p>")
    generated_text = generated_text.replacingOccurrences(of: "[\\t\\n\\r][\\t\\n\\r]+", with: "\n", options: .regularExpression)
    generated_text = generated_text.replacingOccurrences(of: "<p>", with: "")
    generated_text = generated_text.replacingOccurrences(of: "</p>", with: "\n\n")
    generated_text = generated_text.replacingOccurrences(of: "<br>", with: "\n")
    generated_text = generated_text.trimmingCharacters(in: .whitespacesAndNewlines)
    return generated_text.styled(with: content)
}

