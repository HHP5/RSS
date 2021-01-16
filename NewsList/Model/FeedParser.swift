
import Foundation
import Alamofire

class FeedParser: NSObject, XMLParserDelegate{
    private var rssItem: [RSSItem] = []
    private var currentElement = ""
    private var currentTitle: String = ""
    private var currentDescription: String = ""
    private var currentImageURL: String = ""
    
    private var parserCompletionHandler: (([RSSItem])->Void)?
    
    func parseFeed(url: String, completionHandler:  @escaping (([RSSItem])->Void)){
        self.parserCompletionHandler = completionHandler
        
        Alamofire.request(URL(string: url)!, method: .get, parameters: nil).responseData { (response) in
            let parser = XMLParser(data: response.data!)
            
            guard parser.parserError == nil else{
                fatalError("Cannot parse")
            }
            
            parser.delegate = self
            parser.parse()
        }
        
    }
    
    //MARK: - XML Parses Delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElement = elementName
        
        if currentElement == "item"{
            currentTitle = ""
        }
        if currentElement == "description"{
            currentImageURL = ""
            currentDescription = ""
            
        }
    }
    
    
    var separ = [String]()
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let key = "<img src="
        
        if currentElement == "title"{
            currentTitle += string
            
        }
        
        if currentElement == "description"{
            currentDescription += string
            let item = string
            //                 let item = String(data: CDATABlock, encoding: String.Encoding.utf8)
            if item.contains(key) == true{
                separ = (item.components(separatedBy: "<"))
                for i in 0...separ.count-1{
                    if separ[i].contains("img"){
                        currentImageURL += changeImageURL(img: separ[i])
                    }else{
                        currentImageURL += ""
                    }
                }
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item"{
            let rssItem = RSSItem(title: currentTitle, imageURL: currentImageURL)
            self.rssItem.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItem)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
    
    func changeImageURL(img: String) -> String{
        var separation = [String]()
        var separation2 = [String]()
        var notFinishedString: String = ""
        var result: String = ""
        var resultFinish: String = ""
        separation = img.components(separatedBy: CharacterSet.whitespaces)
        for i in 0...separation.count-1{
            if separation[i].contains("https"){
                separation2 = separation[i].components(separatedBy: CharacterSet.symbols)
            }
        }
        for j in 0...separation2.count-1{
            if separation2[j].contains("https"){
                notFinishedString = separation2[j]
            }
        }
        var newArray = Array(notFinishedString)
        newArray.removeLast()
        newArray.removeFirst()
        
        result = String(newArray)
        
        let lastSymbol = result.index(before: result.endIndex)
        if result[lastSymbol] == "\u{22}"{
            result.removeLast()
            resultFinish = String(result)
        }else{
            resultFinish = result
        }
        return resultFinish
    }
    
    
}
