//
//  NetworkService.swift
//  OdooContacts
//
//  Created by Александр Нехай on 3/23/21.
//

import Foundation
import RxSwift

public struct NetworkService {
  private let version = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
  
  let responseSubject = BehaviorSubject<Data?>(value: nil)
  
  func task(for requestType: APIRouter, baseUrl: String) {
    let urlString = baseUrl.appending(requestType.path)
    guard let url = URL(string: urlString) else { return }
    var request = URLRequest(url: url)
    request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.setValue("text/xml", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = combineXML(for: requestType).data(using: .utf8)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data, error == nil else { return }
      responseSubject.onNext(data)
    }
    
    task.resume()
  }
}

private extension NetworkService {

  private func combineXML(for requestType: APIRouter) -> String {
    var xml = [version]
    xml.append(Tag.methodCall.openTag())
    xml.append(requestType.method.name)

    switch requestType {
    case .login(let model):
      xml.append(model.combineAllParams())
    case .contactList(let model):
      xml.append(model.combineAllParams())
    }
    xml.append(Tag.methodCall.closeTag())
    return xml.joined()
  }

}
