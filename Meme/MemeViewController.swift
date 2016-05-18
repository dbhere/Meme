//
//  MemeViewController.swift
//  Meme
//
//  Created by HhhotDog on 16/5/17.
//  Copyright © 2016年 Alexscott. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    //MARK: Properties
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0
    ]
    var keyboardHasOnScreen = false
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        topTextField.delegate = self
        bottomTextField.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
        keyboardHasOnScreen = false
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: Action
    @IBAction func pickUpAnImageFromAlbum() {
        pickUpAnImage(.PhotoLibrary)
    }
    
    @IBAction func pickUpAnImageFromCamera() {
        pickUpAnImage(.Camera)
    }
    
    //MARK: Helper
    private func pickUpAnImage(source:UIImagePickerControllerSourceType){
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = source
        presentViewController(imagePickerVC, animated: true, completion: nil)
    }
    
    //compute keyboard height and change frame
    func keyboardWillShow(notification: NSNotification){
        if !keyboardHasOnScreen{
            view.frame.origin.y -= getKeyboardHeight(notification)
            keyboardHasOnScreen = !keyboardHasOnScreen
        }
    }
    func keyboardWillHide(notification: NSNotification){
        if keyboardHasOnScreen{
            view.frame.origin.y += getKeyboardHeight(notification)
            keyboardHasOnScreen = !keyboardHasOnScreen
        }
    }
    
    private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    //noticifations
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //MARK:UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}

//MARK: TextFieldDelegate
extension MemeViewController: UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
    }

}







