//
//  XMLContactsParseManager.swift
//  OdooContacts
//
//  Created by Александр Нехай on 3/27/21.
//

import Foundation
import RxSwift

class XMLContactsParseManager: NSObject, XMLParserDelegate {
  
  enum XMLField: String {
    case none, id, name, phone, email
    case job = "function"
  }
  
  var id = Int()
  var job = String()
  var name = String()
  var phone = String()
  var email = String()

  public var contactSubject = PublishSubject<ContactModel>()
  var field = XMLField.none
  var elementName: String = String()
  
  override init() {
    super.init()
  }
  
  func decodeXML(data: Data) {
    let decoder = XMLParser(data: data)
    decoder.delegate = self
    decoder.parse()
  }
  
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
    if elementName == "struct" {
      id = Int()
      job = String()
      name = String()
      phone = String()
      email = String()
    }
    
    self.elementName = elementName
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    if elementName == "struct" {
      let contact = ContactModel(id: id, name: name, phone: phone, email: email, job: job)
      contactSubject.onNext(contact)
    }
  }
  
  func parser(_ parser: XMLParser, foundCharacters string: String) {
    let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    guard !data.isEmpty else { return }
    
    self.elementName == "name" ? self.field = XMLField.init(rawValue: data) ?? .none : nil
    
    if self.elementName == "int" && field == .id {
      id += Int(data) ?? 0
    } else if self.elementName == "string" {
      switch field {
      case .name:
        name += data
      case .phone:
        phone += data
      case .email:
        email += data
      case .job:
        job += data
      default:
        break
      }
    }
  }
}
