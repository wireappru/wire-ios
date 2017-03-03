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

protocol ReminderDetailDelegate : AnyObject {
    func didTapMarkAsDone(_ reminderDetailView : MessageReminderDetailsView)
}

class MessageReminderDetailsView : UIView {

    weak var delegate : ReminderDetailDelegate?
    
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var messageLabel : UILabel?
    @IBAction func didTapMarkAsDone(sender: UIButton) {
        self.delegate?.didTapMarkAsDone(self)
    }
}

class MessageReminderDetailsViewController : UIViewController, ReminderDetailDelegate {
    
    var item : ToDoItem! {
        didSet {
            guard let reminderView = self.view as? MessageReminderDetailsView else { return }
            reminderView.titleLabel?.text = item.text ?? "Reply to"
            reminderView.messageLabel?.text = item.message?.textMessageData?.messageText ?? ""
        }
    }
    
    override func loadView() {
        let myView = Bundle.main.loadNibNamed("MessageReminderDetailsView", owner: self, options: nil)!.first as! MessageReminderDetailsView
        myView.delegate = self
        self.view = myView
    }

    func didTapMarkAsDone(_ reminderDetailView: MessageReminderDetailsView) {
        let tempItem = self.item
        ZMUserSession.shared()?.enqueueChanges{
            tempItem?.markAsDone()
        }
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
