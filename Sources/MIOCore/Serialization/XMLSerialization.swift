//
//  XMLSerialization.swift
//
//  Created by MIO Research Labs on 23/08/2020.
//

import Foundation

#if canImport(FoundationXML)
import FoundationXML
#endif

enum XMLSerializationError : Error
{
    case unknown
}

/// Parses XML into a nested dictionary/string structure, an `XMLSerialization`-style convenience.
///
/// Mirrors the shape of `JSONSerialization`: call ``xmlObject(with:options:)`` to turn XML `Data`
/// into a nested `[String: Any]` tree (element name → children/text). Element text is stored under the
/// element's own key; the internal `__XML_TAG_NAME__` marker tracks the current element while parsing.
///
/// ```swift
/// let tree = try XMLSerialization.xmlObject(with: xmlData, options: [])
/// ```
public class XMLSerialization:NSObject, XMLParserDelegate
{
    /// Parses XML `Data` into a nested `Any` structure and returns the root.
    ///
    /// - Parameters:
    ///   - data: The XML bytes to parse.
    ///   - options: Reserved for future use; currently ignored.
    /// - Returns: The parsed tree (typically a nested `[String: Any]`).
    /// - Throws: The underlying `XMLParser` error if parsing fails.
    static public func xmlObject(with data:Data, options:[Any]) throws -> Any
    {
        let xs = XMLSerialization( with: data )
        try xs.parse()
        return xs.results!
    }
        
    let dataContents:Data
    init(with data:Data){
        dataContents = data
    }
    var error:Error? = nil
    func parse() throws {
        let parser = XMLParser( data: dataContents )
        parser.delegate = self
        if parser.parse() == false {
            if error != nil { throw error! }
            throw XMLSerializationError.unknown
        }
    }
    
    /// The parsed result tree, available after parsing completes.
    public var results:Any?

    var elementStack:[Any] = []
    var currentElement:[String:Any]?
    
    var foundCharacters:String = ""
    
    /// `XMLParserDelegate` hook, pushes a new current element. Internal parsing plumbing.
    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if currentElement != nil { elementStack.append(currentElement!) }
        
        currentElement = [:]
        currentElement!["__XML_TAG_NAME__"] = elementName
        
        foundCharacters = ""
    }
    
    /// `XMLParserDelegate` hook, folds the finished element into its parent. Internal parsing plumbing.
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
    
    /// `XMLParserDelegate` hook, accumulates text content. Internal parsing plumbing.
    public func parser(_ parser: XMLParser, foundCharacters string: String) {
        foundCharacters += string
    }

    /// `XMLParserDelegate` hook, captures a parse error to rethrow. Internal parsing plumbing.
    public func parser(_ parser: XMLParser, parseErrorOccurred parseError: any Error) {
        error = parseError
    }
}
