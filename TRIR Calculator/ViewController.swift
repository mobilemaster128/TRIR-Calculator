//
//  ViewController.swift
//  TRIR Calculator
//
//  Created by Sierra on 3/5/17.
//  Copyright © 2017 ReciprocityMedia. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var numberText: UITextField!
    @IBOutlet weak var hourText: UITextField!
    @IBOutlet weak var resultText: UITextField!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var siteLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
        
        let helpTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.clickAdImage))
        helpTap.numberOfTapsRequired = 1 // you can change this value
        helpLabel.isUserInteractionEnabled = true
        helpLabel.addGestureRecognizer(helpTap)
        
        let siteTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.clickAdImage))
        siteTap.numberOfTapsRequired = 1 // you can change this value
        siteLabel.isUserInteractionEnabled = true
        siteLabel.addGestureRecognizer(siteTap)
        
        let viewTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.removeKeyboard))
        viewTap.numberOfTapsRequired = 1 // you can change this value
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(viewTap)
        
        hourText.delegate = self
        numberText.delegate = self
        
        self.addDoneButtonOnKeyboard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterFromKeyboardNotifications()
    }
    
    // MARK: - Keyboard
    
    // Call this method somewhere in your view controller setup code.
    func registerForKeyboardNotifications() {
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(ViewController.keyboardWasShown), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        center.addObserver(self, selector: #selector(ViewController.keyboardWillBeHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unregisterFromKeyboardNotifications () {
        let center = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWasShown (notification: NSNotification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = ((info.object(forKey: UIKeyboardFrameBeginUserInfoKey) as AnyObject).cgRectValue as CGRect!).size
        
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= (kbSize.height + 50);
        if (!aRect.contains(self.activeTextField.frame.origin) ) {
            print(self.activeTextField.frame.origin)
            var currentOffset = self.scrollView.contentOffset
            currentOffset.y += (self.activeTextField.frame.origin.y - kbSize.height + 50)
            self.scrollView.setContentOffset(currentOffset, animated: true)
            //self.scrollView.scrollRectToVisible(self.activeTextField.frame, animated: true)
        }
        else {
            self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden (notification: NSNotification) {
        //let contentInsets: UIEdgeInsets = .zero;
        //scrollView.contentInset = contentInsets;
        //scrollView.scrollIndicatorInsets = contentInsets;
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    // MARK: -  Text Field
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
    
    func clickAdImage() {
        print("click ad")
        gotoUrl(url: "http://safetymanualtoday.com/")
    }
    
    @IBAction func onChangeValue(_ sender: Any) {
        if (numberText.text?.isEmpty)! || (hourText.text?.isEmpty)! {
            return
        }
        
        resultText.text = String(calculateTRIR(number: Int(numberText.text!)!, hour: Int(hourText.text!)!))
    }
    
    func gotoUrl(url: String) {
        let urlUrl = URL(string: url)
        UIApplication.shared.openURL(urlUrl!)
    }
    
    func calculateTRIR(number: Int, hour: Int) -> Double {
        var trir: Double = Double(number)
        trir *= 200000.0
        trir /= Double(hour)
        trir = round(trir * 100) / 100.0
        return trir
    }
    
    func removeKeyboard() {
        numberText.resignFirstResponder()
        hourText.resignFirstResponder()
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ViewController.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.numberText.inputAccessoryView = doneToolbar
        self.hourText.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction() {
        self.numberText.resignFirstResponder()
        self.hourText.resignFirstResponder()
        self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
}

