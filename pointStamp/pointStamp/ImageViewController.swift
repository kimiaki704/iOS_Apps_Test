//
//  ImageViewController.swift
//  pointStamp
//
//  Created by 鈴木公章 on 2018/01/31.
//  Copyright © 2018年 kimio. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    
    imageView.image = saveImage

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
