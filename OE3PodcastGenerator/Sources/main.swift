//
//  main.swift
//  OE3PodcastGenerator
//
//  Created by Patrick Steiner on 01.08.18.
//  Copyright © 2018 Patrick Steiner. All rights reserved.
//

import Foundation
import os.log

let downloadManager = DownloadManager()
let audioManager = AudioManager()
let feedManager = FeedManager()

os_log(.debug, "Staring download...")
downloadManager.download { result in

    switch result {
    case .success(let url):
        let fileSize: Int
        let audioDuration: Double

        os_log(.debug, "Download was successful url: %{public}@", url.absoluteString)

        // get file size in bytes
        if let data = try? Data(contentsOf: url) {
            fileSize = [UInt8](data).count
            os_log(.debug, "File size %{public}d bytes", fileSize)
        } else {
            fileSize = 0
        }

        // get mp3 duration in seconds
        audioDuration = audioManager.getDurationFromURL(url)
        os_log(.debug, "File duration in seconds: %{public}f", audioDuration)

        let xmlDocument = feedManager.createFeed(fileLength: fileSize, audioDuration: audioDuration)
        //        let xmlString = feedManager.createStringFromXMLDocument(xmlDocument)
        //        print("🐞: xml: \(xmlString)")

        if let desktopDirectory = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first {
            let filePath = desktopDirectory.appendingPathComponent("podcast.xml")

            do {
                try feedManager.writeXMLDocumentToFile(xmlDocument, path: filePath)
                exit(EXIT_SUCCESS)
            } catch {
                os_log(.error, "Failed to write file to: %{public}@ with error: %{public}@", filePath.absoluteString, error.localizedDescription)
                exit(EXIT_FAILURE)
            }
        } else {
            exit(EXIT_FAILURE)
        }
    case .failure(let error):
        os_log(.debug, "Download failed with error %{public}@", error.localizedDescription)
        exit(EXIT_FAILURE)
    }
}

RunLoop.main.run()

