//
//  stampViewController.swift
//  stampCamera
//
//  Created by SasakiTatsuya on 2018/01/07.
//  Copyright © 2018年 S.Tatsuya. All rights reserved.
//

import UIKit

class stampViewController: UIViewController, UICollectionViewDataSource,
UICollectionViewDelegate {
    
    
    @IBOutlet weak var stampCollection: UICollectionView!
    
    let stampArray = [UIImage(named: "p.jpeg")]
    
    @IBAction func close(sender: AnyObject){
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stampArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        imageView.image = stampArray[indexPath.row]
        
        /*
        var presentingViewController: UIViewController?
        let VC = presentingViewController as! [stampViewController]
        */
        
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.image = stampArray[indexPath.row]
        delegate.isStampAdded = true*/
        
        let VC = presentingViewController as! ViewController
        VC.stampImage = stampArray[indexPath.row]
        self.dismiss(animated: true, completion: nil)
    }

    



}
