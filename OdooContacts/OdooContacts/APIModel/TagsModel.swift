//
//  TagsModel.swift
//  OdooContacts
//
//  Created by Александр Нехай on 3/23/21.
//

import Foundation

protocol OpenCloseTags {
  func openTag() -> String
  func closeTag() -> String
}

public enum Tag: String, OpenCloseTags {
  case methodCall
  case methodName
  case params
  case param
  case value
  case member
  case name
  
  func openTag() -> String {
    return "<\(self.rawValue)>"
  }
  
  func closeTag() -> String {
    return "</\(self.rawValue)>"
  }
}

public enum DataType: String, OpenCloseTags {
  case string
  case int
  case strukt = "struct"
  case array
  case data
  
  func openTag() -> String {
    return "<\(self.rawValue)>"
  }
  
  func closeTag() -> String {
    return "</\(self.rawValue)>"
  }
}
