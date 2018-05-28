 
 import UIKit
 
 class ViewController: UIViewController, UIGestureRecognizerDelegate {
  
  @IBOutlet weak var testLabel: UILabel!
  
  @IBOutlet var rotationRecognizer: UIRotationGestureRecognizer!
  @IBOutlet var pinchRecognizer: UIPinchGestureRecognizer!
  
  //ドラッグ終了時のアフィン変換
  var prevEndPinch:CGAffineTransform = CGAffineTransform()
  var prevEndRotate:CGAffineTransform = CGAffineTransform()
  //ドラッグ中の前回アフィン変換
  var prevPinch:CGAffineTransform = CGAffineTransform()
  var prevRotate:CGAffineTransform = CGAffineTransform()
  
  
  //最初からあるメソッド
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //デリゲート先に自分を設定する。
    rotationRecognizer.delegate = self
    pinchRecognizer.delegate = self
    
    //アフィン変換の初期値を設定する。
    prevEndPinch = testLabel.transform
    prevEndRotate = testLabel.transform
    prevPinch = testLabel.transform
    prevRotate = testLabel.transform
  }
  
  

  
  
  //ピンチ時の呼び出しメソッド
  @IBAction func pinchLabel(sender: UIPinchGestureRecognizer) {
    
    //前回ドラッグ終了時の拡大縮小を引き継いだアフィン変換を作る。
    let nowPinch = prevEndPinch.scaledBy(x: sender.scale, y: sender.scale)
    
    //回転のアフィン変換と合わせたものをラベルに登録する。
    testLabel.transform = nowPinch.concatenating(prevRotate)
    
    //今回の拡大縮小のアフィン変換をクラス変数に保存する。
    prevPinch = nowPinch
    
    if(sender.state == UIGestureRecognizerState.ended) {
      //ドラッグ終了時の拡大縮小のアフィン変換をクラス変数に保存する。
      prevEndPinch = nowPinch
    }
  }
  
  //回転時の呼び出しメソッド
  @IBAction func rotateLabel(sender: UIRotationGestureRecognizer) {
    
    //前回ドラッグ終了時の回転を引き継いだアフィン変換を作る。
    let nowRotate = prevEndRotate.rotated(by: sender.rotation)
    
    //回転のアフィン変換と合わせたものをラベルに登録する。
    testLabel.transform = nowRotate.concatenating(prevPinch)
    
    //今回の回転のアフィン変換をクラス変数に保存する。
    prevRotate = nowRotate
    
    if(sender.state == UIGestureRecognizerState.ended) {
      //ドラッグ終了時の回転のアフィン変換をクラス変数に保存する。
      prevEndRotate = nowRotate
    }
  }
  
  
  //リコグナイザーの同時検知を許可するメソッド
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
 }
