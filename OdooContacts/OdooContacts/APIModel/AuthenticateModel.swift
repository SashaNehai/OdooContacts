//
//  AuthenticateModel.swift
//  OdooContacts
//
//  Created by Александр Нехай on 3/23/21.
//

import Foundation

struct AuthenticateModel {
  let databaseUrl: String
  let databaseName: String
  let username: String
  let password: String
  
  init(databaseUrl: String?, databaseName: String?, username: String?, password: String?) {
    self.databaseUrl = databaseUrl ?? ""
    self.databaseName = databaseName ?? ""
    self.username = username ?? ""
    self.password = password ?? ""
  }
  
  private func combineParam(type: DataType, param: Any?) -> String {
    return "\(Tag.param.openTag())\(Tag.value.openTag())\(type.openTag())\(param ?? "")\(type.closeTag())\(Tag.value.closeTag())\(Tag.param.closeTag())"
  }
  
  private func combineStruct() -> String {
    return "\(Tag.param.openTag())\(DataType.strukt.openTag())\(DataType.strukt.closeTag())\(Tag.param.closeTag())"
  }
  
  func combineAllParams() -> String {
    let param1 = combineParam(type: .string, param: self.databaseName)
    let param2 = combineParam(type: .string, param: self.username)
    let param3 = combineParam(type: .string, param: self.password)
    let param4 = combineStruct()
    return "\(Tag.params.openTag())\(param1)\(param2)\(param3)\(param4)\(Tag.params.closeTag())"
  }
}
