//
//  Date+Formatter.swift
//  OE3PodcastGenerator
//
//  Created by Patrick Steiner on 26.07.18.
//  Copyright © 2018 Patrick Steiner. All rights reserved.
//

import Foundation

extension Date {
    var formattedPubDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_AT")

        // should look like: Tue, 24 Jul 2018 16:00:01 GMT (rfc 822 date)
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"

        return dateFormatter.string(from: self)
    }

    var formattedTitle: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_AT")

        // should look like: 24. Juli 2018 (20:00 Uhr)
        dateFormatter.dateFormat = "dd.MMM.yyy (HH:mm 'Uhr')"
        
        return dateFormatter.string(from: self)
    }

    var formattedDescription: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "de_AT")

        // should look like: 24. Juli 2018 (20:00 Uhr)
        dateFormatter.dateFormat = "'OE3 Nachrichten um' HH 'Uhr'"

        return dateFormatter.string(from: self)
    }

    var fullHourDate: Date? {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day, .hour], from: self))
    }
}
