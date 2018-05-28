//
//  ViewController.swift
//  stampCamera
//
//  Created by SasakiTatsuya on 2018/01/07.
//  Copyright © 2018年 S.Tatsuya. All rights reserved.
//

import UIKit

// ユーティリティメソッド CGPoint同士の足し算を+で書けるようにする
func -(_ left:CGPoint, _ right:CGPoint)->CGPoint{
  return CGPoint(x:left.x - right.x, y:left.y - right.y)
}
// ユーティリティメソッド CGPoint同士の引き算を-で書けるようにする
func +(_ left:CGPoint, _ right:CGPoint)->CGPoint{
  return CGPoint(x:left.x + right.x, y:left.y + right.y)
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  
  //リコグナイザーの同時検知を許可するメソッド
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  // タッチ開始時のUIViewのorigin
  var orgOrigin: CGPoint!
  // タッチ開始時の親ビュー上のタッチ位置
  var orgParentPoint : CGPoint!
  
  
  @objc func handlePanGesture(_ sender: UIPanGestureRecognizer) {
    switch sender.state {
    case UIGestureRecognizerState.began:
      // タッチ開始:タッチされたビューのoriginと親ビュー上のタッチ位置を記録しておく
      orgOrigin = sender.view?.frame.origin
      orgParentPoint = sender.translation(in: self.view)
      break
    case UIGestureRecognizerState.changed:
      // 現在の親ビュー上でのタッチ位置を求める
      let newParentPoint = sender.translation(in: self.view)
      // パンジャスチャの継続:タッチ開始時のビューのoriginにタッチ開始からの移動量を加算する
      sender.view?.frame.origin = orgOrigin + newParentPoint - orgParentPoint
      break
    default:
      break
    }
  }


    @IBOutlet weak var imageView: UIImageView!
    var stampImage: UIImage? = nil
    var Image: UIImage? = nil
    
    /*
    //以下拡大のプログラム
    @IBAction func gesture(_ sender: UIPanGestureRecognizer) {
        let cstamp = view!
        if cstamp.transform.isIdentity {
            cstamp.transform = CGAffineTransform(scaleX: 3, y: 3)
        } else {
            cstamp.transform = CGAffineTransform.identity
        }
    }
     */
    
    
    @IBAction func back(_ sender: Any) {
        let stamps = imageView.subviews
        stamps.last?.removeFromSuperview()
    }
    
    @IBAction func save(_ sender: Any) {
        saveImageWithStamps()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Screen Size の取得
        let stampWidth:CGFloat = imageView.frame.size.width
        let stampHeight:CGFloat = imageView.frame.size.height
       
        // タッチ操作を enable
        //imageView.isUserInteractionEnabled = true
        
        //self.view.addSubview(imageView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    private func addStamp(with point: CGPoint) {
      
      if stampImage != nil {
        let stampSize = CGSize(width: 32, height: 32)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: stampSize))
        
        imageView.center = point
        imageView.image = stampImage
        imageView.addGestureRecognizer(
          UIPanGestureRecognizer(target:self, action: #selector(handlePanGesture)))
        
        self.view.addSubview(imageView)
        stampImage = nil
      }
      
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
    
    
    //以下view移動のコード
    /*override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // タッチイベントを取得
        let touchEvent = touches.first!
        
        // ドラッグ前の座標
        let preDx = touchEvent.previousLocation(in: self.view).x
        let preDy = touchEvent.previousLocation(in: self.view).y
        
        // ドラッグ後の座標
        let newDx = touchEvent.location(in: self.view).x
        let newDy = touchEvent.location(in: self.view).y
        
        // ドラッグしたx座標の移動距離
        let dx = newDx - preDx
        print("x:\(dx)")
        
        // ドラッグしたy座標の移動距離
        let dy = newDy - preDy
        print("y:\(dy)")
        
        // 画像のフレーム
        var viewFrame: CGRect = imageView.frame
        
        viewFrame.origin.x += dx
        viewFrame.origin.y += dy
        
        imageView.frame = viewFrame
        
        self.view.addSubview(imageView)
        
    }*/
    
    
}



