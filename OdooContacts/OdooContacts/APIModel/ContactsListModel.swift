//
//  ContactsListModel.swift
//  OdooContacts
//
//  Created by Александр Нехай on 3/23/21.
//

import Foundation

struct ContactListRequestModel {
  let databaseUrl: String
  let databaseName: String
  let userId: Int
  let password: String
  
  init(databaseUrl: String?, databaseName: String?, userId: Int, password: String?) {
    self.databaseUrl = databaseUrl ?? ""
    self.databaseName = databaseName ?? ""
    self.userId = userId
    self.password = password ?? ""
  }
  
  private func combineParam(type: DataType, param: Any?) -> String {
    return "\(Tag.param.openTag())\(Tag.value.openTag())\(type.openTag())\(param ?? "")\(type.closeTag())\(Tag.value.closeTag())\(Tag.param.closeTag())"
  }
  
  private func combineArray() -> String {
    return "\(Tag.param.openTag())\(DataType.array.openTag())\(DataType.array.closeTag())\(Tag.param.closeTag())"
  }
  
  private func combineSearchFields() -> String {
    return "\(Tag.param.openTag())\(Tag.value.openTag())\(DataType.strukt.openTag())\(Tag.member.openTag())\(Tag.name.openTag())fields\(Tag.name.closeTag())\(Tag.value.openTag())\(DataType.array.openTag())\(DataType.data.openTag())\(Tag.value.openTag())\(DataType.string.openTag())name\(DataType.string.closeTag())\(Tag.value.closeTag())\(Tag.value.openTag())\(DataType.string.openTag())phone\(DataType.string.closeTag())\(Tag.value.closeTag())\(Tag.value.openTag())\(DataType.string.openTag())email\(DataType.string.closeTag())\(Tag.value.closeTag())\(Tag.value.openTag())\(DataType.string.openTag())function\(DataType.string.closeTag())\(Tag.value.closeTag())\(DataType.data.closeTag())\(DataType.array.closeTag())\(Tag.value.closeTag())\(Tag.member.closeTag())\(DataType.strukt.closeTag())\(Tag.value.closeTag())\(Tag.param.closeTag())"
  }
  
  func combineAllParams() -> String {
    let param1 = combineParam(type: .string, param: self.databaseName)
    let param2 = combineParam(type: .int, param: self.userId)
    let param3 = combineParam(type: .string, param: self.password)
    let param4 = combineParam(type: .string, param: "res.partner")
    let param5 = combineParam(type: .string, param: "search_read")
    let param6 = combineArray()
    let param7 = combineSearchFields()
    return "\(Tag.params.openTag())\(param1)\(param2)\(param3)\(param4)\(param5)\(param6)\(param7)\(Tag.params.closeTag())"
  }
}
