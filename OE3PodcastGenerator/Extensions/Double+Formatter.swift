//
//  Double+Formatter.swift
//  OE3PodcastGenerator
//
//  Created by Patrick Steiner on 27.07.18.
//  Copyright © 2018 Patrick Steiner. All rights reserved.
//

import Foundation

extension Double {
    var formattedDuration: String {
        let formatter = DateComponentsFormatter()
        
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        formatter.includesTimeRemainingPhrase = false

        return formatter.string(from: self) ?? "0:00:00"
    }
}
