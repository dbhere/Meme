//
//  MemeViewController.swift
//  Meme
//
//  Created by HhhotDog on 16/5/17.
//  Copyright © 2016年 Alexscott. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
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
    
    //MARK:UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}

