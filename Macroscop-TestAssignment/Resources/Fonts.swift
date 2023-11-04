//
//  Fonts.swift
//  Macroscop-TestAssignment
//
//  Created by Богдан Полыгалов on 04.11.2023.
//

import UIKit

extension UIFont {
    // Шрифты заголовков
    static var headline1 = UIFont.systemFont(ofSize: 34, weight: .bold)
    static var headline2 = UIFont.systemFont(ofSize: 28, weight: .bold)
    static var headline3 = UIFont.systemFont(ofSize: 22, weight: .bold)
    static var headline4 = UIFont.systemFont(ofSize: 20, weight: .bold)

    // Шрифты основного текста
    static var bodyBold = UIFont.systemFont(ofSize: 17, weight: .bold)
    static var bodyRegular = UIFont.systemFont(ofSize: 17, weight: .regular)

    // Шрифты для подписей
    static var caption1 = UIFont.systemFont(ofSize: 15, weight: .regular)
    static var caption2 = UIFont.systemFont(ofSize: 13, weight: .regular)
    static var caption3 = UIFont.systemFont(ofSize: 10, weight: .regular)
}
