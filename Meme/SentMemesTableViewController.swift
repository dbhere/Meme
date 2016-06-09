//
//  SentMemesTableViewController.swift
//  Meme
//
//  Created by HhhotDog on 16/6/8.
//  Copyright © 2016年 Alexscott. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
    var memes:[Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 15)!,
        NSStrokeWidthAttributeName: -3.0
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addMeme))
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    func addMeme(){
        let nextVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        self.presentViewController(nextVC, animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SentMemesTableViewCell") as! SentMemesTableViewCell
        let meme = memes[indexPath.row]
        cell.memeImage.image = meme.originalImage
        cell.topBottomInfo.text = (meme.topText ?? "") + (meme.bottomText ?? "")
        cell.topLabel.attributedText = NSAttributedString(string: meme.topText ?? "", attributes: memeTextAttributes)
        cell.bottomLabel.attributedText = NSAttributedString(string: meme.bottomText ?? "", attributes: memeTextAttributes)
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let nextVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        nextVC.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
