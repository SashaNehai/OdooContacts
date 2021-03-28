//
//  ContactsViewController.swift
//  OdooContacts
//
//  Created by Александр Нехай on 3/22/21.
//

import UIKit

class ContactsViewController: BaseViewController, XMLParserDelegate {
  
  private let tableView = UITableView()
  
  var contacts: [ContactModel] = []
  var viewModel: ContactsViewModel?
  
  convenience init() {
    self.init(viewModel: nil)
  }
  
  init(viewModel: ContactsViewModelImpl?) {
    super.init(nibName: nil, bundle: nil)
    self.viewModel = viewModel
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.addSubview(tableView)
    tableViewSetup()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.pin.all()

    viewModel?.contactObservable.subscribe(onNext: { contact in
      self.contacts.append(contact)
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }).disposed(by: disposeBag)
  }
}

private extension ContactsViewController {
  func tableViewSetup() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.rowHeight = 120
    tableView.register(ContactCell.self, forCellReuseIdentifier: "cell")
  }
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contacts.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ContactCell else { return UITableViewCell() }
    let contact = contacts[indexPath.row]
    cell.setup(with: contact)
    return cell
  }
}
