

import UIKit

class StampViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
  let stampArray = [UIImage(named: "p"), UIImage(named: "fusaiyou"), UIImage(named: "goukaku"), UIImage(named: "hi"), UIImage(named: "hugoukaku"), UIImage(named: "ka"), UIImage(named: "kakunin"), UIImage(named: "saiyou"), UIImage(named: "sikyu"), UIImage(named: "sumi"), UIImage(named: "stamp1")]
  

  @IBOutlet weak var stampCollectionView: UICollectionView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return stampArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! StampCollectionViewCell
    cell.imageView.image = stampArray[indexPath.row]
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let VC = presentingViewController as! ViewController
    VC.stampImage = stampArray[indexPath.row]!
    
    self.dismiss(animated: true, completion: nil)
    
  }

}
