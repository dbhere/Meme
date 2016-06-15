//
//  MemeDetailViewController.swift
//  Meme
//
//  Created by HhhotDog on 16/6/8.
//  Copyright © 2016年 Alexscott. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    //MARK: Properties
    var meme:Meme!
    
    //MARK: Outlets
    @IBOutlet weak var memeImage: UIImageView!
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.image = meme.memedImage
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: #selector(editMeme))
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    //MARK: Action
    func editMeme(){
        let nextVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        nextVC.editMeme = meme
        self.presentViewController(nextVC, animated: true, completion: nil)
    }
}
