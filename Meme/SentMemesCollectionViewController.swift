//
//  SentMemesCollectionViewController.swift
//  Meme
//
//  Created by HhhotDog on 16/6/9.
//  Copyright © 2016年 Alexscott. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SentMemesCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController {
    //MARK: Properties
    var memes:[Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    let itemSpcae:CGFloat = 3.0
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 10)!,
        NSStrokeWidthAttributeName: -3.0
    ]
    
    //MARK: Outlets
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adjustCellSize(itemSpcae)
        flowLayout.minimumLineSpacing = itemSpcae
        flowLayout.minimumInteritemSpacing = itemSpcae
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addMeme))
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
    }
    
    override func viewWillLayoutSubviews() {
        adjustCellSize(itemSpcae)
    }
    
    func addMeme(){
        let nextVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeViewController") as! MemeViewController
        self.presentViewController(nextVC, animated: true, completion: nil)
    }
    
    //MARK: deal with cell size
    private func adjustCellSize(space: CGFloat){
        var dimensison = (view.frame.size.width - 2 * space) / 3
        if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation){
            dimensison = (view.frame.size.width - 4 * space) / 5
        }
        flowLayout.itemSize = CGSizeMake(dimensison, dimensison)
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SentMemesCollectionViewCell
        let meme = memes[indexPath.row]
        cell.originalImage.image = meme.originalImage
        cell.topLabel.attributedText = NSAttributedString(string: meme.topText ?? "", attributes: memeTextAttributes)
        cell.bottomLabel.attributedText = NSAttributedString(string: meme.bottomText ?? "", attributes: memeTextAttributes)
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let nextVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        nextVC.meme = memes[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    

}
