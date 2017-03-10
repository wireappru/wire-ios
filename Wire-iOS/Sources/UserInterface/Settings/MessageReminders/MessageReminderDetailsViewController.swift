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
    func didTapRevealButton(_ reminderDetailView : MessageReminderDetailsView)
    func didTapDeleteButton(_ reminderDetailView : MessageReminderDetailsView)
    func didSelectNewDate(_ reminderDetailView : MessageReminderDetailsView, date: Date)

}

class MessageReminderDetailsView : UIView {

    weak var delegate : ReminderDetailDelegate?
    
    @IBOutlet var titleLabel : UILabel?
    @IBOutlet var messageLabel : UILabel?
    @IBOutlet var dateLabel : UILabel?
    @IBOutlet var datePicker : UIDatePicker!
    @IBOutlet var datePickerContainer : UIView!
    @IBOutlet var doneButton : UIButton!
    
    @IBAction func didTapMarkAsDone(sender: UIButton) {
        self.delegate?.didTapMarkAsDone(self)
    }
    
    @IBAction func didTapRevealButton(sender:UIButton) {
        self.delegate?.didTapRevealButton(self)
    }
    
    @IBAction func didTapDeleteButton(sender:UIButton) {
        self.delegate?.didTapDeleteButton(self)
    }
    
    @IBAction func didTapRescheduleButton(sender:UIButton) {
        if !self.datePickerContainer.isHidden {
            delegate?.didSelectNewDate(self, date: self.datePicker.date)
        }
        UIView.animate(withDuration: 0.2) { 
            self.datePickerContainer.isHidden = !self.datePickerContainer.isHidden
        }
    }
}

class MessageReminderDetailsViewController : UIViewController, ReminderDetailDelegate {
    
    var item : ToDoItem! {
        didSet {
            guard let reminderView = self.view as? MessageReminderDetailsView else { return }
            reminderView.titleLabel?.text = item.text ?? "Reply to"
            reminderView.messageLabel?.text = item.message?.textMessageData?.messageText ?? ""
            if let date = item.dueDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .short
                let dateString = dateFormatter.string(from: date)
                reminderView.dateLabel?.text = "Due at \(dateString)"
            } else {
                reminderView.dateLabel?.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
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
        _ = navigationController?.popViewController(animated: true)
    }
    
    func didTapRevealButton(_ reminderDetailView: MessageReminderDetailsView) {
        guard let message = item.message else { return }
        ZClientViewController.shared().select(message.conversation!, focusOnView: true, animated: true)
    }
    
    func didTapDeleteButton(_ reminderDetailView: MessageReminderDetailsView) {
        let tempItem = self.item
        ZMUserSession.shared()?.enqueueChanges{
            tempItem?.delete(inUserSession: ZMUserSession.shared()!)
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    func didSelectNewDate(_ reminderDetailView: MessageReminderDetailsView, date: Date) {
        let tempItem = self.item
        ZMUserSession.shared()?.enqueueChanges{
            tempItem?.reschedule(newDate: date)
        }
    }
}
