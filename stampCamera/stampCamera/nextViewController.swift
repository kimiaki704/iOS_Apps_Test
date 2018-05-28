//
//  nextViewController.swift
//  stampCamera
//
//  Created by 鈴木公章 on 2018/01/22.
//  Copyright © 2018年 S.Tatsuya. All rights reserved.
//

import UIKit

class nextViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
      
      
      imageView.image = stampImages

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

  @IBAction func returnAction(_ sender: Any) {
    
    dismiss(animated: true, completion: nil)
  }
}
