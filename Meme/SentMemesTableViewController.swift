//
//  SentMemesTableViewController.swift
//  Meme
//
//  Created by HhhotDog on 16/6/8.
//  Copyright © 2016年 Alexscott. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    //MARK: Properties
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var memes:[Meme] {
        return appDelegate.memes
    }
    var memeTextAttributes:[String: AnyObject]{
        return appDelegate.memeTextAttributes
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addMeme))
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    //MARK: Action
    func addMeme(){
        let nextVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        self.presentViewController(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func backToMemeList(segue: UIStoryboardSegue){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemesTableViewCell") as! SentMemesTableViewCell
        let meme = memes[indexPath.row]
        cell.memeImage.image = meme.originalImage
        cell.topBottomInfo.text = (meme.topText ?? "") + " " + (meme.bottomText ?? "")
        cell.topLabel.attributedText = NSAttributedString(string: meme.topText ?? "", attributes: memeTextAttributes)
        cell.bottomLabel.attributedText = NSAttributedString(string: meme.bottomText ?? "", attributes: memeTextAttributes)
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let nextVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        nextVC.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}
