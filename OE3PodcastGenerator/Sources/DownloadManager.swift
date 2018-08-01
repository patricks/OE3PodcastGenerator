//
//  Downloader.swift
//  OE3PodcastGenerator
//
//  Created by Patrick Steiner on 24.07.18.
//  Copyright © 2018 Patrick Steiner. All rights reserved.
//

import Foundation

class DownloadManager {

    enum DownloadError: Error {
        case download
        case noData
        case copyToDestination
    }

    enum DownloadResult {
        case success(url: URL)
        case failure(error: Error)
    }

    private let defaultMp3URL = "https://oe3meta.orf.at/oe3mdata/StaticAudio/Nachrichten.mp3"

    func download(completion: @escaping (_ result: DownloadResult) -> Void) {
        guard let downloadURL = URL(string: defaultMp3URL) else { return }

        // TODO: check if url session on macOS checks the ETag from the server.

        let downloadTask = URLSession.shared.downloadTask(with: downloadURL) { (url, response, error) in
            if let error = error {
                completion(.failure(error: error))
            } else {
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    if let url = url {
                        do {
                            if let desinationURL = try self.moveDownloadFromTmpDirectory(sourceURL: url) {
                                completion(.success(url: desinationURL))
                            } else {
                                completion(.failure(error: DownloadError.copyToDestination))
                            }

                        } catch let error {
                            completion(.failure(error: error))
                        }
                    } else {
                        completion(.failure(error: DownloadError.noData))
                    }
                } else {
                    completion(.failure(error: DownloadError.download))
                }
            }
        }

        downloadTask.resume()
    }

    private var destinationURL: URL? {
        let fileManager = FileManager.default

        if let desktopDirectory = fileManager.urls(for: .desktopDirectory, in: .userDomainMask).first {
            return desktopDirectory.appendingPathComponent("news.mp3")
        } else {
            return nil
        }
    }

    func moveDownloadFromTmpDirectory(sourceURL: URL) throws -> URL? {
        guard let fileURL = destinationURL else { return nil }
        let fileManager = FileManager.default

        // remove previous file
        try? fileManager.removeItem(at: fileURL)

        try fileManager.moveItem(at: sourceURL, to: fileURL)

        return fileURL
    }
}
