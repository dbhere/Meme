//
//  MemeEditorViewController.swift
//  Meme
//
//  Created by HhhotDog on 16/5/17.
//  Copyright © 2016年 Alexscott. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //MARK: Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navItem: UINavigationItem!
    
    //MARK: Properties
    
    var editMeme: Meme?
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -3.0
    ]
    //mark whether keyboard has been on screen
    var keyboardHasOnScreen = false
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //set textfield attributes
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        UIApplication.sharedApplication().statusBarHidden = true
        navItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: #selector(shareYourMeme))
        navItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(cancelMeme))
        if let meme = editMeme {
            imageView.image = meme.originalImage
            topTextField.text = meme.topText
            bottomTextField.text = meme.bottomText
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
        keyboardHasOnScreen = false
        navItem.leftBarButtonItem?.enabled = (imageView.image != nil)
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
    
    //MARK:navigation bar buttion method
    func shareYourMeme(){
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { activityType, success, items, error in
            if success{
                self.save()
                self.performSegueWithIdentifier("backToMemeList", sender: self)
                UIApplication.sharedApplication().statusBarHidden = false
            }
        }
        presentViewController(activityVC, animated: true, completion: nil)
    }
    func cancelMeme(){
        UIApplication.sharedApplication().statusBarHidden = false
        self.performSegueWithIdentifier("backToMemeList", sender: self)
    }
    
    //MARK: Helper
    private func generateMemedImage() -> UIImage {
        //hide toolbar and navbar
        configureBars(true)
        
        //UIGraphicsBeginImageContext(self.view.frame.size)
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, false, 0)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //show navbar and toolbar
        configureBars(false)
        return memedImage
    }
    
    private func configureBars(hidden: Bool){
        navBar.hidden = hidden
        toolBar.hidden = hidden
    }
    
    private func save() {
        //Create the meme
        let meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: imageView.image!, memedImage: generateMemedImage())
        
        //add meme to shared model in application delegate
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.memes.append(meme)
        
        
    }
    
    private func pickUpAnImage(source:UIImagePickerControllerSourceType){
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = source
        presentViewController(imagePickerVC, animated: true, completion: nil)
    }
    
    //compute keyboard height and change frame
    var oldKeyboard:CGFloat = CGFloat(0)
    func keyboardWillShow(notification: NSNotification){
        if  bottomTextField.isFirstResponder(){
            let newKeyBoard = getKeyboardHeight(notification)
            if keyboardHasOnScreen{
                view.frame.origin.y += oldKeyboard
            }
            view.frame.origin.y -= newKeyBoard
            oldKeyboard = newKeyBoard
            keyboardHasOnScreen = true
        }
    }
    func keyboardWillHide(notification: NSNotification){
        if keyboardHasOnScreen && bottomTextField.isFirstResponder(){
            view.frame.origin.y += getKeyboardHeight(notification)
            keyboardHasOnScreen = false
        }
    }
    
    private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }
    //noticifations
    func subscribeToKeyboardNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
extension MemeEditorViewController: UITextFieldDelegate{
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