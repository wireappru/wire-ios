//
// Wire
// Copyright (C) 2017 Wire Swiss GmbH
// 
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
// 


import UIKit
import zmessaging
import Cartography
import WireExtensionComponents
import CocoaLumberjackSwift

class MessageReminderCell : UITableViewCell {

    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var messageLabel : UILabel?
    @IBOutlet var stackView : UIStackView?
    @IBOutlet var doneLabel : UILabel?
    
    func toggleMessageText(){
        messageLabel?.numberOfLines = (messageLabel?.numberOfLines == 0) ? 1 : 0
//        guard let stackView = stackView else { return }
//        let isExpanded = stackView.arrangedSubviews[1].isHidden
//        stackView.arrangedSubviews[1].isHidden = !isExpanded
//        stackView.arrangedSubviews[2].isHidden = isExpanded
    }

}


@objc class MessageReminderViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var clientsTableView: UITableView?
    let topSeparator = OverflowSeparatorView()

    var editingList: Bool = false {
        didSet {
            if (self.editingList) {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ClientListViewController.endEditing(_:)))
            }
            else {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(ClientListViewController.startEditing(_:)))
            }
            
            self.navigationItem.setHidesBackButton(self.editingList, animated: true)
            self.clientsTableView?.setEditing(self.editingList, animated: true)
        }
    }
    var items: [ToDoItem] = [] {
        didSet{
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            sortedItems = [:]
            sectionTitles = []
            self.items.forEach{
                guard let date = $0.dueDate else {
                    if let oldItems = self.sortedItems["Some Day"] {
                        self.sortedItems["Some Day"] = oldItems + [$0]
                    } else {
                        sectionTitles.append("Some Day")
                        self.sortedItems["Some Day"] = [$0]
                    }
                    return
                }
                let formattedDate = dateFormatter.string(from: date)
                if let oldItems = self.sortedItems[formattedDate] {
                    self.sortedItems[formattedDate] = oldItems + [$0]
                } else {
                    sectionTitles.append(formattedDate)
                    self.sortedItems[formattedDate] = [$0]
                }
            }
        }
    }
    var sortedItems: [String : [ToDoItem]] = [:]
    var sectionTitles : [String] = []
    
    let detailedView: Bool
    
    required init(detailedView: Bool = false) {
        self.detailedView = detailedView
        
        super.init(nibName: nil, bundle: nil)
        self.title = NSLocalizedString("self.settings.message_reminders.title", comment:"")
        self.edgesForExtendedLayout = []
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addReminder(sender:)))
        
        if let session =  ZMUserSession.shared() {
            self.items = ToDoItem.allItems(inUserSession: session)
        }
    }
    
    func addReminder(sender: UIBarButtonItem){
        let vc = ReminderOptionsViewController()
        navigationController?.present(vc, animated: true, completion: nil)
    }
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibNameOrNil:nibBundleOrNil:) has not been implemented")
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return [.portrait]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear
        
        self.createTableView()
        self.view.addSubview(self.topSeparator)
        self.createConstraints()
        
        if self.traitCollection.userInterfaceIdiom == .pad {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(ClientListViewController.backPressed(_:)))
        }
        
        if let rootViewController = self.navigationController?.viewControllers.first
            , self.isEqual(rootViewController) {
                self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ClientListViewController.backPressed(_:)))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let session =  ZMUserSession.shared() {
            self.items = ToDoItem.allItems(inUserSession: session)
        }
        self.clientsTableView?.reloadData()
    }

    fileprivate func createTableView() {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped);
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 80
        tableView.register(UINib(nibName: "MessageReminderCell", bundle: nil), forCellReuseIdentifier: "MessageReminderCell")
        
        tableView.isEditing = self.editingList
        tableView.backgroundColor = UIColor.clear
        tableView.separatorColor = UIColor(white: 1, alpha: 0.1)
        self.view.addSubview(tableView)
        self.clientsTableView = tableView
    }
    
    fileprivate func createConstraints() {
        if let clientsTableView = self.clientsTableView {
            constrain(self.view, clientsTableView, self.topSeparator) { selfView, clientsTableView, topSeparator in
                clientsTableView.edges == selfView.edges
                
                topSeparator.left == clientsTableView.left
                topSeparator.right == clientsTableView.right
                topSeparator.top == clientsTableView.top
            }
        }
    }
    
    // MARK: - Actions
    
    func startEditing(_ sender: AnyObject!) {
        self.editingList = true
    }
    
    func endEditing(_ sender: AnyObject!) {
        self.editingList = false
    }
    
    func backPressed(_ sender: AnyObject!) {
        self.navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    func displayError(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("general.ok", comment: ""), style: .default) { [unowned alert] (_) -> Void in
            alert.dismiss(animated: true, completion: .none)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: .none)
    }
    
    // MARK: - UITableViewDataSource & UITableViewDelegate
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sortedItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionTitles[section]
        guard let itemsInSection = sortedItems[sectionTitle] else { return 0 }
        return itemsInSection.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerFooterView = view as? UITableViewHeaderFooterView {
            headerFooterView.textLabel?.textColor = UIColor(white: 1, alpha: 0.4)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let headerFooterView = view as? UITableViewHeaderFooterView {
            headerFooterView.textLabel?.textColor = UIColor(white: 1, alpha: 0.4)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = itemAtIndexPath(indexPath: indexPath) else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier:"MessageReminderCell", for: indexPath) as! MessageReminderCell
        cell.titleLabel?.text = item.text ?? "Reply to:"
        cell.messageLabel?.text = item.message?.textMessageData?.messageText ?? ""

        cell.doneLabel?.text = item.isDone ? "🔵" : "⚪️"
        return cell
    }
    
    func itemAtIndexPath(indexPath: IndexPath) -> ToDoItem? {
        let sectionTitle = sectionTitles[indexPath.section]
        guard let itemsInSection = sortedItems[sectionTitle] else { return nil }
        return itemsInSection[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // delete
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let item = itemAtIndexPath(indexPath: indexPath) else {
            return nil
        }
        
        let markAsDone = UITableViewRowAction(style: .normal, title: "Done") { (action, indexPath) in
            ZMUserSession.shared()?.performChanges {
                item.markAsDone()
            }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        markAsDone.backgroundColor = UIColor.green
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            ZMUserSession.shared()?.performChanges{
                item.delete(inUserSession: ZMUserSession.shared()!)
            }
            self.items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        delete.backgroundColor = UIColor.red
        
        return [markAsDone, delete]
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = itemAtIndexPath(indexPath: indexPath) else {
            return
        }
        let controller = MessageReminderDetailsViewController()
        controller.item = item
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.topSeparator.scrollViewDidScroll(scrollView: scrollView)
    }
}

