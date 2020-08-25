//
//  XMLSerialization.swift
//  
//
//  Created by Javier Segura Perez on 23/08/2020.
//

import Foundation

#if canImport(FoundationXML)
import FoundationXML
#endif

public class XMLSerialization:NSObject, XMLParserDelegate
{
    static public func xmlObject(with data:Data, options:[Any]) throws -> Any
    {
        let xs = XMLSerialization(with: data)
        xs.parse()
        return xs.results!
    }
        
    let dataContents:Data
    init(with data:Data){
        dataContents = data
    }
    
    func parse() {
        let parser = XMLParser(data: dataContents)
        parser.delegate = self
        parser.parse()
    }
    
    public var results:Any?
    
    var elementStack:[Any] = []
    var currentElement:[String:Any]?
    
    var foundCharacters:String = ""
    
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if currentElement != nil { elementStack.append(currentElement!) }
        
        currentElement = [:]
        currentElement!["__XML_TAG_NAME__"] = elementName
        
        foundCharacters = ""
    }
    
    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
                
        if currentElement != nil {

            if (currentElement!["__XML_TAG_NAME__"] as! String) == elementName {
                if foundCharacters.count > 0 {
                    var prevElement = elementStack.last as! [String:Any]
                    prevElement[elementName] = foundCharacters
                    elementStack[elementStack.count - 1] = prevElement
                }
            }
        }
        else {
            currentElement = elementStack.popLast() as? [String:Any]
            var prevElement = elementStack.last as? [String:Any]
            if prevElement != nil {
                prevElement![elementName] = currentElement
                elementStack[elementStack.count - 1] = prevElement!
            }
            else {
                results = currentElement
            }
        }
        
        foundCharacters = ""
        currentElement = nil
        //elementStack.popLast()
    }
    
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        foundCharacters += string
    }
}
