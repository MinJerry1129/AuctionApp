import UIKit
import Alamofire
import JTMaterialSpinner

class purchaseGVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var productgVC : ProductGVC! = nil
    var product_id = ""
    var id : [String] = []
    var name : [String] = []
    var imageUrl : [String] = []
    var count : [String] = []
    @IBOutlet weak var catCollectionView: UICollectionView!
    var spinnerView = JTMaterialSpinner()
    override func viewDidLoad() {
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        Alamofire.request(Global.baseUrl + "igetcategories.php").responseJSON{ returnValue in
            print(returnValue)
            if let value = returnValue.value as? [String: AnyObject] {
                let status = value["status"] as! String
                if status == "ok" {
                    let devices = value["categories"] as? [[String: Any]]
                    for i in 0 ... (devices?.count)!-1 {
                        self.id.append(devices?[i]["id"] as! String)
                        self.name.append(devices?[i]["name"] as! String)
                        self.imageUrl.append(devices?[i]["image"] as! String)
                        let aaaaa = devices?[i]["count"]
                        print(aaaaa!)
                        self.count.append("\(aaaaa!)")
                    }
                    self.catCollectionView.dataSource = self
                    self.catCollectionView.delegate = self
                    self.spinnerView.endRefreshing()
                }else{
                    let alert = UIAlertController(title: "Alert", message: "No Categories", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        super.viewDidLoad()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return id.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catcell", for: indexPath) as! CollectionViewCell
        cell.catName.text = name[indexPath.row]
        cell.catCount.text = count[indexPath.row]
        cell.catImg.layer.borderWidth = 1
        cell.catImg.layer.masksToBounds = false
        cell.catImg.layer.borderColor = UIColor.black.cgColor
        cell.catImg.layer.cornerRadius = cell.catImg.frame.height*0.2
        cell.catImg.clipsToBounds = true
        
        let imgUrl = Global.imageUrl + imageUrl[indexPath.row]
        print(imgUrl)
        let url = URL(string: imgUrl)
        do {
            let data = try Data(contentsOf: url!)
            let image = UIImage(data: data)
            cell.catImg.image = image
        }catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Defaults.save(id[indexPath.item], with: Defaults.PRODUCT_KEY)
        print(id[indexPath.item])
        self.productgVC = self.storyboard?.instantiateViewController(withIdentifier: "productgVC") as? ProductGVC
        self.present(self.productgVC, animated: true, completion: nil)
    }
}

