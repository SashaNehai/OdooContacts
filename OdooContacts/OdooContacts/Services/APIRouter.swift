//
//  APIRouter.swift
//  OdooContacts
//
//  Created by Александр Нехай on 3/23/21.
//

import Foundation

enum APIRouter {
  case login(model: AuthenticateModel)
  case contactList(model: ContactListRequestModel)
    
  var path: String {
    switch self {
    case .login:
      return "xmlrpc/2/common"
    case .contactList:
      return "xmlrpc/2/object"
    }
  }
  
  var method: Method {
    switch self {
    case .login:
      return Method.authenticate
    case .contactList:
      return Method.execute_kw
    }
  }
}
