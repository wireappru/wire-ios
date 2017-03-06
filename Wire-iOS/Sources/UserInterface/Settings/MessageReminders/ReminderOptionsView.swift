//
//  ReminderOptionsView.swift
//  Wire-iOS
//
//  Created by Sabine Geithner on 03/03/17.
//  Copyright © 2017 Zeta Project Germany GmbH. All rights reserved.
//

import Foundation


protocol  ReminderDelegate : AnyObject {
    @available(iOS 9.0, *)
    func didSaveReminder(_ reminderView: ReminderOptionsView, time: Date?, title: String?)
    func didPressCloseButton(_ reminderView: ReminderOptionsView)
}

@available(iOS 9.0, *)
class ReminderOptionsView :  UIView {
    
    @IBOutlet var blurView : UIVisualEffectView!
    @IBOutlet var titleField : UITextField!
    @IBOutlet var dateSwitch : UISwitch!
    @IBOutlet var datePicker : UIDatePicker!
    @IBOutlet var stackView: UIStackView!
    weak var delegate : ReminderDelegate?
    
    @IBAction func didToggle(dateSwitch: UISwitch) {
        UIView.animate(withDuration: 0.2) {
            self.stackView.arrangedSubviews[3].isHidden = !dateSwitch.isOn
        }
    }
    
    @IBAction func didSaveReminder(sender: UIButton) {
        let time : Date? = dateSwitch.isOn ? datePicker.date : nil
        delegate?.didSaveReminder(self, time: time, title: titleField.text ?? "Reply to:")
    }
    
    @IBAction func didPressCloseButton(sender: UIButton) {
        delegate?.didPressCloseButton(self)
    }
}


class ReminderOptionsViewController : UIViewController, ReminderDelegate {

    var message : ZMConversationMessage!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func loadView() {
        if #available(iOS 9.0, *) {
            let myView = Bundle.main.loadNibNamed("ReminderOptionsView", owner: self, options: nil)!.first as! ReminderOptionsView
            myView.delegate = self
            myView.stackView.arrangedSubviews[3].isHidden = true
            
            self.view = myView
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    @available(iOS 9.0, *)
    func didSaveReminder(_ reminderView: ReminderOptionsView, time: Date?, title: String?) {
        ZMUserSession.shared()?.enqueueChanges { [weak self] in
            guard let `self` = self else { return }
            _ = ToDoItem.addToDo(for: self.message, atDate: time, withDescription: title, inUserSession: ZMUserSession.shared()!)
        }
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func didPressCloseButton(_ reminderView: ReminderOptionsView) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}



