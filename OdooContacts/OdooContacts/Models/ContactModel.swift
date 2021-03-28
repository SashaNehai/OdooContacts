//
//  ContactModel.swift
//  OdooContacts
//
//  Created by Александр Нехай on 3/22/21.
//

import Foundation

struct ContactModel {
  var id: Int
  var name: String
  var phone: String
  var email: String
  var job: String
  
  init(id: Int, name: String, phone: String, email: String, job: String) {
    self.id = id
    self.name = name
    self.phone = phone
    self.email = email
    self.job = job
  }
}
