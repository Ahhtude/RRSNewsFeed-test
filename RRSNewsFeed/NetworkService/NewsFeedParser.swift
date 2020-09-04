//
//  NewsFeedParser.swift
//  RRSNewsFeed
//
//  Created by Sergey berdnik on 04.09.2020.
//  Copyright © 2020 Sergey berdnik. All rights reserved.
//

import Foundation

class NewsFeedParser: NSObject, XMLParserDelegate {
    private var rssItem: [RSSNewsFeed] = []
    private var currentElement = ""
    
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentDescription: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentPubDate: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionHandler: (([RSSNewsFeed])->Void)?
    
    func parseNewsFeed(url: String, completionHandler: (([RSSNewsFeed]) -> Void)?) -> Void {
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSesstion = URLSession.shared
        let task = urlSesstion.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
}

//MARK: - XML Delegate
    extension NewsFeedParser {
        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            currentElement = elementName
            if currentElement == "item" {
                currentTitle = ""
                currentDescription = ""
                currentPubDate = ""
            }
        }
        
        func parser(_ parser: XMLParser, foundCharacters string: String) {
            switch currentElement {
            case "title": currentTitle += string
            case "description": currentDescription += string
            case "pubdate": currentPubDate += string
            default: break
            }
        }
        
        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            if elementName == "item" {
                let rssItem = RSSNewsFeed(title: currentTitle, description: currentDescription, pubData: currentPubDate)
                self.rssItem.append(rssItem)
            }
        }
        
        func parserDidEndDocument(_ parser: XMLParser) {
            parserCompletionHandler?(rssItem)
        }
        
        func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
            print(parseError.localizedDescription)
        }
}
