//
//  MemeDetailViewController.swift
//  Meme
//
//  Created by HhhotDog on 16/6/8.
//  Copyright © 2016年 Alexscott. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    var meme:Meme!
    
    @IBOutlet weak var memeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.image = meme.memedImage
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: #selector(editMeme))
    }
    
    func editMeme(){
        let nextVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        nextVC.editMeme = meme
        self.presentViewController(nextVC, animated: true, completion: nil)
    }

    
    

    

}
