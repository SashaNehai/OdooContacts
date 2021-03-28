//
//  ContactsViewModel.swift
//  OdooContacts
//
//  Created by Александр Нехай on 3/23/21.
//

import Foundation
import RxSwift

protocol ContactsViewModel: ViewModel {
  var contactObservable: Observable<ContactModel> { get }
}

final class ContactsViewModelImpl: ContactsViewModel {
  
  public var contactSubject = PublishSubject<ContactModel>()
  public var contactObservable: Observable<ContactModel> {
    return contactSubject.asObservable()
  }

  private let disposeBag = DisposeBag()
  private let network = NetworkService()
  private let parser = XMLContactsParseManager()
  
  init(authenticateModel: AuthenticateModel?, userId: Int) {
    self.initiateRequest(authenticateModel: authenticateModel, userId: userId)
    self.initiateSubscriptions()
  }
  
  private func initiateRequest(authenticateModel: AuthenticateModel?, userId: Int) {
    guard let authenticateModel = authenticateModel else { return }
    let model = ContactListRequestModel(databaseUrl: authenticateModel.databaseUrl,
                                        databaseName: authenticateModel.databaseName,
                                        userId: userId,
                                        password: authenticateModel.password)
    network.task(for: .contactList(model: model), baseUrl: model.databaseUrl)
  }
  
  private func initiateSubscriptions() {
    network.responseSubject.asObservable().subscribe(onNext: { [weak self] response in
      guard let self = self, let data = response else { return }
      self.parser.decodeXML(data: data)
    }).disposed(by: disposeBag)
    
    parser.contactSubject.asObservable().debug().subscribe(onNext: { [weak self] contact in
      guard let self = self else { return }
      self.contactSubject.onNext(contact)
    }).disposed(by: disposeBag)
  }
}
