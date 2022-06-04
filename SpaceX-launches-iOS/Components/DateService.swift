//
//  DateService.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 29.05.2022.
//

import Foundation

public class DateService{
    static func convertStringToDate(from date: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSSZ") -> String? {
        let formater = DateFormatter()
        formater.dateFormat = format
        guard let result = formater.date(from: date) else { return "" }

        formater.dateStyle = .medium
        formater.locale = Locale(identifier: "en_US")

        return formater.string(from: result)
    }
}
