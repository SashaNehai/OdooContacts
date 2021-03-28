//
//  Method.swift
//  OdooContacts
//
//  Created by Александр Нехай on 3/23/21.
//

import Foundation

public enum Method: String {
  case authenticate
  case execute_kw
  
  var name: String {
    methodNameXMLString(self.rawValue)
  }
}

func methodNameXMLString(_ methodName: String) -> String {
  return "\(Tag.methodName.openTag())\(methodName)\(Tag.methodName.closeTag())"
}
