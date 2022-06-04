//
//  DateService.swift
//  SpaceX-launches-MVC-iOS
//
//  Created by Elizeus on 29.05.2022.
//

import Foundation

public class DateService{
    static func convertStringToDate(from date: String, format: String = "en_US") -> String? {
        let formater = DateFormatter()
        formater.dateStyle = .medium
        formater.locale = Locale(identifier: format)
        let originalDate = formater.date(from: date)
        return formater.string(from: originalDate ?? Date())
    }
}
