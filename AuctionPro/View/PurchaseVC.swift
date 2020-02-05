import UIKit
import Alamofire
import JTMaterialSpinner
import SDWebImage

class PurchaseVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var productVC : ProductVC! = nil
    var loger : LoginController! = nil
    var profile : ProfileVC! = nil
    var purchase : PurchaseVC! = nil
    var winnerVC : WinnerVC! = nil
    var contactVC : ContactVC! = nil
    var homeVC: HomeVC! = nil
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.size.width - 80) / 2, height: 150)
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
        
        cell.catImg?.sd_setImage(with: URL(string: imgUrl), completed: nil)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        Defaults.save(id[indexPath.item], with: Defaults.PRODUCT_KEY)
        print(id[indexPath.item])
        self.productVC = self.storyboard?.instantiateViewController(withIdentifier: "productVC") as? ProductVC
        self.present(self.productVC, animated: true, completion: nil)
    }
    @IBAction func gobackbtn(_ sender: Any) {
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        self.present(self.homeVC, animated: true, completion: nil)
    }
    @IBAction func loginBack(_ sender: UIButton) {
        self.loger = self.storyboard?.instantiateViewController(withIdentifier: "firstVC") as? LoginController
        self.present(self.loger, animated: true, completion: nil)
    }
    
    @IBAction func viewProfile(_ sender: UIButton) {
        self.profile = self.storyboard?.instantiateViewController(withIdentifier: "profileVC") as? ProfileVC
        self.present(self.profile, animated: true, completion: nil)
    }
    
    @IBAction func viewHome(_ sender: UIButton) {
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        self.present(self.homeVC, animated: true, completion: nil)
    }
    
    @IBAction func viewWonbids(_ sender: UIButton) {
        self.winnerVC = self.storyboard?.instantiateViewController(withIdentifier: "winnerVC") as? WinnerVC
        self.present(self.winnerVC, animated: true, completion: nil)
    }
    @IBAction func viewContact(_ sender: Any) {
        self.contactVC = self.storyboard?.instantiateViewController(withIdentifier: "contactVC") as? ContactVC
        self.present(self.contactVC, animated: true, completion: nil)
    }
    
}
