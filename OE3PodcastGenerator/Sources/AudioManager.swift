//
//  AudioManager.swift
//  OE3PodcastGenerator
//
//  Created by Patrick Steiner on 24.07.18.
//  Copyright © 2018 Patrick Steiner. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager {
    func getDurationFromURL(_ url: URL) -> Double {
        let asset = AVURLAsset(url: url)
        let audioDuration = asset.duration
        let duration = CMTimeGetSeconds(audioDuration)

        return Double(duration)
    }
}
