//
//  SMTableVC.swift
//  SideMenu
//
//  Created by Liliya Sayfutdinova on 17.11.2020.
//

import UIKit

class SMTableVC: UITableViewController {

    let items:[Int] = [1,2,3,4,5]
    static let selectedNotification: String = "SelectedMenu"
    static let selectedNumberKey: String = "selectedNumber"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SMCell", for: indexPath)

        cell.textLabel?.text = "\(items[indexPath.row])"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notification.Name(SMTableVC.selectedNotification), object: nil, userInfo: [SMTableVC.selectedNumberKey : self.items[indexPath.row]])
        self.navigationController?.dismiss(animated: true)
    }
}
