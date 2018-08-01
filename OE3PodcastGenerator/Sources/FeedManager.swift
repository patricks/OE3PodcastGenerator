//
//  FeedManager.swift
//  OE3PodcastGenerator
//
//  Created by Patrick Steiner on 26.07.18.
//  Copyright © 2018 Patrick Steiner. All rights reserved.
//

import Foundation

// TODO:
// - set output directory

class FeedManager {

    func createFeed(fileLength: Int, audioDuration: Double) -> XMLDocument {
        let rssElement = createPodcastFeed(fileLength: fileLength, audioDuration: audioDuration)

        let xmlDocument = XMLDocument(rootElement: rssElement)
        xmlDocument.characterEncoding = "UTF-8"
        xmlDocument.version = "1.0"

        return xmlDocument
    }

    func createStringFromXMLDocument(_ xmlDocument: XMLDocument) -> String {
        let options: XMLNode.Options = [.nodePrettyPrint, .nodeCompactEmptyElement]

        return xmlDocument.xmlString(options: options)
    }

    func writeXMLDocumentToFile(_ xmlDocument: XMLDocument, path: URL) throws {
        let xmlString = createStringFromXMLDocument(xmlDocument)
        try xmlString.write(to: path, atomically: true, encoding: .utf8)
    }

    private func createPodcastFeed(fileLength: Int, audioDuration: Double) -> XMLElement {
        let description = "Der Ö3 Nachrichten-Podcast bietet einen Überblick über die wichtigen Themen des Tages."

        let rssElement = XMLElement(name: "rss")

        let attributes = [
            "version": "2.0",
            "xmlns:atom": "http://www.w3.org/2005/Atom",
            "xmlns:itunes": "http://www.itunes.com/dtds/podcast-1.0.dtd"
        ]

        rssElement.setAttributesWith(attributes)

        let channelElement = XMLElement(name: "channel")
        let titleElement = XMLElement(name: "title", stringValue: "Ö3 Nachrichten-Podcast")
        let linkElement = XMLElement(name: "link", stringValue: "http://oe3.orf.at/programm/stories/podcast/")
        let descriptionElement = XMLElement(name: "description", stringValue: description)
        let languageElement = XMLElement(name: "language", stringValue: "de-AT")
        let copyrightElement = XMLElement(name: "copyright", stringValue: "2018 ORF Hitradio Ö3")
        let pubDateElement = XMLElement(name: "pubDate", stringValue: Date().formattedPubDate)

        let itunesImageElement = XMLElement(name: "itunes:image")
        itunesImageElement.setAttributesWith(["href" : "http://files.orf.at/podcast/oe3/41.png"])

        let itunesCategoryElement = XMLElement(name: "itunes:category")
        itunesCategoryElement.setAttributesWith(["text" : "News &amp; Politics"])

        let itunesAuthorElement = XMLElement(name: "itunes:author", stringValue: "Hitradio Ö3")
        let itunesExplicitElement = XMLElement(name: "itunes:explicit", stringValue: "no")
        let itunesKeywordsElement = XMLElement(name: "itunes:keywords")
        let itunesSubtitleElement = XMLElement(name: "itunes:subtitle", stringValue: "Die Themen des Tages.")
        let itunesSummaryElement = XMLElement(name: "itunes:summary", stringValue: description)

        rssElement.addChild(channelElement)
        channelElement.addChild(titleElement)
        channelElement.addChild(linkElement)
        channelElement.addChild(descriptionElement)
        channelElement.addChild(languageElement)
        channelElement.addChild(copyrightElement)
        channelElement.addChild(pubDateElement)
        channelElement.addChild(createItunesOwnerElement())
        channelElement.addChild(itunesImageElement)
        channelElement.addChild(itunesCategoryElement)
        channelElement.addChild(itunesAuthorElement)
        channelElement.addChild(itunesExplicitElement)
        channelElement.addChild(itunesKeywordsElement)
        channelElement.addChild(itunesSubtitleElement)
        channelElement.addChild(itunesSummaryElement)

        channelElement.addChild(createPodcastItem(fileLength: fileLength, audioDuration: audioDuration))

        return rssElement
    }

    private func createPodcastItem(fileLength: Int, audioDuration: Double) -> XMLElement {
        let itemElement = XMLElement(name: "item")

        let titleElement = XMLElement(name: "title", stringValue: itemTitle)
        let linkElement = XMLElement(name: "link", stringValue: "https://oe3meta.orf.at/oe3mdata/StaticAudio/Nachrichten.mp3")

        let descriptionElement = XMLElement(name: "description", stringValue: Date().formattedDescription)

        let enclosureElement = XMLElement(name: "enclosure")

        let attributes = [
            "url": "https://oe3meta.orf.at/oe3mdata/StaticAudio/Nachrichten.mp3",
            "length": "\(fileLength)",
            "type": "audio/mpeg"
        ]

        enclosureElement.setAttributesWith(attributes)

        let pubDateElement = XMLElement(name: "pubDate", stringValue: Date().formattedPubDate)
        let guidElement = XMLElement(name: "guid", stringValue: UUID().uuidString)

        let itunesDurationElement = XMLElement(name: "itunes:duration", stringValue: audioDuration.formattedDuration)
        let itunesAuthorElement = XMLElement(name: "itunes:author", stringValue: "Hitradio Ö3 - oe3.orf.at")
        let itunesExplicitElement = XMLElement(name: "itunes:explicit", stringValue: "no")
        let itunesKeywordsElement = XMLElement(name: "itunes:keywords")
        let itunesSubtitleElement = XMLElement(name: "itunes:subtitle", stringValue: "Die Themen des Tages.")
        let itunesSummaryElement = XMLElement(name: "itunes:summary", stringValue: Date().formattedDescription)

        itemElement.addChild(titleElement)
        itemElement.addChild(linkElement)
        itemElement.addChild(descriptionElement)
        itemElement.addChild(enclosureElement)
        itemElement.addChild(pubDateElement)
        itemElement.addChild(guidElement)
        itemElement.addChild(itunesDurationElement)
        itemElement.addChild(itunesAuthorElement)
        itemElement.addChild(itunesExplicitElement)
        itemElement.addChild(itunesKeywordsElement)
        itemElement.addChild(itunesSubtitleElement)
        itemElement.addChild(itunesSummaryElement)
        
        return itemElement
    }

    private func createItunesOwnerElement() -> XMLElement {
        let itunesElement = XMLElement(name: "itunes:owner")
        let itunesEmailElement = XMLElement(name: "itunes:email", stringValue: "netinfo.oe3@orf.at")
        let itunesNameElement = XMLElement(name: "itunes:name", stringValue: "Hitradio Ö3")

        itunesElement.addChild(itunesEmailElement)
        itunesElement.addChild(itunesNameElement)

        return itunesElement
    }

    private var itemTitle: String {
        guard let fullHourDate = Date().fullHourDate else { return "" }

        return fullHourDate.formattedTitle
    }
}
