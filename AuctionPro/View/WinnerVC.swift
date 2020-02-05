import UIKit
import Alamofire
import JTMaterialSpinner
class WinnerVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var loger : LoginController! = nil
    var profile : ProfileVC! = nil
    var purchase : PurchaseVC! = nil
    var winnerVC : WinnerVC! = nil
    var contactVC : ContactVC! = nil
    var homeVC: HomeVC! = nil
    var winnerviewVC : WinnerViewVC! = nil
    var product_id = ""
    var id : [String] = []
    var name : [String] = []
    var price : [String] = []
    var imageUrl : [String] = []
    var endtime : [String] = []
    var bids : [String] = []
    var endtime_sel : [Int] = []
    var timer : Timer! = nil
    var count = 1
    @IBOutlet weak var tableView: UITableView!
    var spinnerView = JTMaterialSpinner()
    override func viewDidLoad() {
        //        print(purchaseVC.product_id)
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        let parameters: Parameters = ["username": Defaults.getNameAndValue(Defaults.USERNAME_KEY)]
        Alamofire.request(Global.baseUrl + "igetwinner.php", method: .post, parameters: parameters).responseJSON{ returnValue in
            print(returnValue)
            if let value = returnValue.value as? [String: AnyObject] {
                let status = value["status"] as! String
                if status == "ok" {
                    let devices = value["products"] as? [[String: Any]]
                    for i in 0 ... (devices?.count)!-1 {
                        self.id.append(devices?[i]["id"] as! String)
                        self.name.append(devices?[i]["name"] as! String)
                        self.imageUrl.append(devices?[i]["image"] as! String)
                        self.price.append(devices?[i]["price"]as! String)
                    }
                    
                    self.tableView.rowHeight = 110
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return id.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! tableViewCell
        cell.winname.text = name[indexPath.row]
        cell.winprice.text = price[indexPath.row]
        cell.winimage.layer.borderWidth = 1
        cell.winimage.layer.masksToBounds = false
        cell.winimage.layer.borderColor = UIColor.black.cgColor
        cell.winimage.layer.cornerRadius = cell.winimage.frame.height*0.2
        cell.winimage.clipsToBounds = true
        let str = imageUrl[indexPath.row]
        let str0 = str.components(separatedBy: "_split_")
        let imgUrl = Global.imageUrl + str0[0]
        print(imgUrl)
        let url = URL(string: imgUrl)
        do {
            let data = try Data(contentsOf: url!)
            let image = UIImage(data: data)
            cell.winimage.image = image
            
        }catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        self.product_id = id[indexPath.item]
        print(id[indexPath.item])
        self.winnerviewVC = self.storyboard?.instantiateViewController(withIdentifier: "winnerviewVC") as? WinnerViewVC
        self.winnerviewVC.winnerVC = self
        self.present(self.winnerviewVC, animated: true, completion: nil)
        
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
    
    @IBAction func viewpurchase(_ sender: UIButton) {
        self.purchase = self.storyboard?.instantiateViewController(withIdentifier: "purchaseVC") as? PurchaseVC
        self.present(self.purchase, animated: true, completion: nil)
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


