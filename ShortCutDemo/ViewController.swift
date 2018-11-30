//
//  ViewController.swift
//  ShortCutDemo
//
//  Created by 丁暐哲 on 2018/11/26.
//  Copyright © 2018 PeterDinDin. All rights reserved.
//

import UIKit
import Intents
import IntentsUI
import CoreServices
import CoreSpotlight


class ViewController: UIViewController {
    
   
    

    @IBOutlet weak var ButtonView: UIView!
    @IBOutlet weak var llBalance: UILabel!
    private var price: Int {
        get {
            return UserDefaults.standard.integer(forKey: "GoldBalance")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "GoldBalance")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setCoustomIntent()
        setupIntents()
        setButton()
        llBalance.text = "現在有\(price)元"
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setCoustomIntent() {
        let intent = GetMoneyIntent()
        
        intent.coin = "5"
        intent.trashCoin = "500"
        intent.suggestedInvocationPhrase = "試說下去領500"
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.identifier = "com.myapp.shortcuts.buy.money"
        interaction.donate { (error) in
            
        }
    }
    
    
    func setButton() {
        let intent = GetMoneyIntent()
        intent.coin = "2"
        intent.trashCoin = "30"


        let addShortcutButton = INUIAddVoiceShortcutButton(style: .whiteOutline)
        addShortcutButton.shortcut = INShortcut(intent: intent)
        addShortcutButton.delegate = self
        
        addShortcutButton.translatesAutoresizingMaskIntoConstraints = false
        ButtonView.addSubview(addShortcutButton)
        ButtonView.centerXAnchor.constraint(equalTo: addShortcutButton.centerXAnchor).isActive = true
        ButtonView.centerYAnchor.constraint(equalTo: addShortcutButton.centerYAnchor).isActive = true
    }

    func setupIntents() {
        let activity = NSUserActivity(activityType: "PeterDinDin.Demo.ShortCutDemo.SayFetchBalance")
        activity.title = "要空投來摟"
        activity.userInfo = ["say": "Money"]
        activity.isEligibleForSearch = true
        activity.isEligibleForPrediction = true
        activity.suggestedInvocationPhrase = "請給我黃金"
        
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeItem as String)
        let image = UIImage(named: "money-bag")!
        attributes.thumbnailData = image.pngData()
        attributes.contentDescription = "要空投、，救台灣"
        activity.contentAttributeSet = attributes
        self.view.userActivity = activity
        activity.becomeCurrent()
    }
 
    func getMoney() {
        price += 1
        llBalance.text = "現在有\(price)元"
    }
    
}

extension ViewController: INUIAddVoiceShortcutButtonDelegate {
    
    func present(_ addVoiceShortcutViewController: INUIAddVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        addVoiceShortcutViewController.delegate = self
        present(addVoiceShortcutViewController, animated: true, completion: nil)
    }
    
    /// - Tag: edit_phrase
    func present(_ editVoiceShortcutViewController: INUIEditVoiceShortcutViewController, for addVoiceShortcutButton: INUIAddVoiceShortcutButton) {
        editVoiceShortcutViewController.delegate = self
        present(editVoiceShortcutViewController, animated: true, completion: nil)
    }
}

extension ViewController: INUIAddVoiceShortcutViewControllerDelegate {
    
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController,
                                        didFinishWith voiceShortcut: INVoiceShortcut?,
                                        error: Error?) {
        
        
        if let error = error as NSError? {
//            os_log("Error adding voice shortcut: %@", log: OSLog.default, type: .error, error)
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: INUIEditVoiceShortcutViewControllerDelegate {
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController,
                                         didUpdate voiceShortcut: INVoiceShortcut?,
                                         error: Error?) {
        if let error = error as NSError? {
//            os_log("Error adding voice shortcut: %@", log: OSLog.default, type: .error, error)
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController,
                                         didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
