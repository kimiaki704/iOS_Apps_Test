//
//  ViewController.swift
//  stampCamera
//
//  Created by SasakiTatsuya on 2018/01/07.
//  Copyright © 2018年 S.Tatsuya. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var imageView: UIImageView!
    var stampImage: UIImage? = nil
    
    var textImage: UIImage? = nil
    
    @IBAction func back(_ sender: Any) {
        let stamps = imageView.subviews
        stamps.last?.removeFromSuperview()
    }
    
    @IBAction func save(_ sender: Any) {
        saveImageWithStamps()
    }
    
    /*
    @IBAction func character(_ sender: Any) {
    }
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    
    
    private func addStamp(with point: CGPoint) {
        
        let stampSize = CGSize(width: 32, height: 32)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: stampSize))
        
        imageView.center = point
        
        imageView.image = stampImage
        
        self.imageView.addSubview(imageView)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let point = touches.first?.location(in: imageView) else { return }
        let stampSize: CGFloat = 32
        let maxY = imageView.frame.maxY - stampSize
        
        guard maxY > point.y else { return }
        
        addStamp(with: point)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        if delegate.isStampAdded {
            delegate.isStampAdded = false
            
            let stamp = UIImageView()
            let _:CGFloat = 100
            stamp.frame  = CGRect(x:0, y:0, width:32, height:32)
            //stamp.frame = CGFloat(0, 0, stampSize, stampSize)
            stamp.center = self.view.center
            stamp.contentMode = .scaleAspectFit
            stamp.image = delegate.image
        
            self.view.addSubview(stamp)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                dismiss(animated: true, completion: nil)
            }
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String : Any]) {
                
                let image = info[UIImagePickerControllerOriginalImage] as! UIImage
                imageView.image = image
                self.dismiss(animated: true, completion: nil)
            }

    @IBAction func photo(_ sender: Any) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = .photoLibrary
            cameraPicker.delegate = self
            
            present(cameraPicker, animated: true, completion: nil)
        }

    
    
    private func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }

    private func saveImageWithStamps() {
        
        UIGraphicsBeginImageContext(imageView.frame.size)
        guard let context = UIGraphicsGetCurrentContext() else {
            displayAlert(title: "エラー", message: "画像の保存に失敗しました")
            return
        }
        imageView.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            displayAlert(title: "エラー", message: "画像の保存に失敗しました")
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(ViewController.image(image:didFinishSaveImageWithError:contextInfo:)), nil)
        UIGraphicsEndImageContext()
    }
    
    @objc func image(image: UIImage, didFinishSaveImageWithError error: NSError?, contextInfo: UnsafeMutableRawPointer) {
        
        switch error {
        case let .some(error):
            displayAlert(title: "エラー", message: error.localizedDescription)
            
        case .none:
            displayAlert(title: "成功", message: "画像が保存されました！")
        }
    }
    
    /*
    private func editCaracter() {
    }
    */
    
}



