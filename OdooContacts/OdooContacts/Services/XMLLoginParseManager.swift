//
//  XMLLoginParseManager.swift
//  OdooContacts
//
//  Created by Александр Нехай on 3/27/21.
//

import Foundation
import RxSwift

class XMLLoginParseManager: NSObject, XMLParserDelegate {
  var userId = PublishSubject<Int>()
  var elementName: String = String()
  var id = Int()
  
  override init() {
    super.init()
  }
  
  func decodeXML(data: Data) {
    let decoder = XMLParser(data: data)
    decoder.delegate = self
    decoder.parse()
  }
  
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
    if elementName == "param" {
      id = Int()
    }
    self.elementName = elementName
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    if elementName == "param" {
      userId.onNext(id)
    }
  }
  
  func parser(_ parser: XMLParser, foundCharacters string: String) {
    let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    if !data.isEmpty, self.elementName == "int"  {
      id += Int(data) ?? 0
    }
  }
}
