import UIKit
import Alamofire
import JTMaterialSpinner
class ProductVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var purchaseVC : PurchaseVC! = nil
    var productviewVC : ProductViewVC! = nil
    var loger : LoginController! = nil
    var profile : ProfileVC! = nil
    var purchase : PurchaseVC! = nil
    var winnerVC : WinnerVC! = nil
    var contactVC : ContactVC! = nil
    var homeVC: HomeVC! = nil
    
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
        self.view.addSubview(spinnerView)
        spinnerView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 50.0) / 2.0, y: (UIScreen.main.bounds.size.height-50)/2, width: 50, height: 50)
        
        spinnerView.circleLayer.lineWidth = 2.0
        spinnerView.circleLayer.strokeColor = UIColor.orange.cgColor
        spinnerView.beginRefreshing()
        //        print(purchaseVC.product_id)
        let parameters: Parameters = ["catid": Defaults.getNameAndValue(Defaults.PRODUCT_KEY)]
        Alamofire.request(Global.baseUrl + "igetproducts.php", method: .post, parameters: parameters).responseJSON{ returnValue in
            print(returnValue)
            if let value = returnValue.value as? [String: AnyObject] {
                let status = value["status"] as! String
                if status == "ok" {
                    let devices = value["products"] as? [[String: Any]]
                    for i in 0 ... (devices?.count)!-1 {
                        self.id.append(devices?[i]["id"] as! String)
                        self.name.append(devices?[i]["name"] as! String)
                        self.bids.append(devices?[i]["countdown"]as! String)
                        self.imageUrl.append(devices?[i]["image"] as! String)
                        self.price.append(devices?[i]["price"]as! String)
                        self.endtime.append(devices?[i]["endtime"]as! String)
                    }
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.fire), userInfo: nil, repeats: true)
                    self.tableView.rowHeight = 110
                    
                    self.tableView.delegate = self
                    self.tableView.dataSource = self
                    self.spinnerView.endRefreshing()
                }else{
                    let alert = UIAlertController(title: "Alert", message: "No Categories", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.dismiss(animated: true, completion: nil)
                    
                    
                }
            }
        }
        super.viewDidLoad()
    }
    @objc func fire()
    {
        var aaaaaa = 0
        for i in 0 ... id.count - 1 {
            if endtime[i] != "Ended"
            {
                if endtime[i] != "Past"
                {
                    var components: Array = endtime[i].components(separatedBy: ":")
                    let hours = Int(components[0])
                    let minutes = Int(components[1])
                    let seconds = Int(components[2])
                    var sec = hours! * 3600 + minutes! * 60 + seconds!
                    sec = sec - 1
                    if sec == 0 {
                        endtime[i] = "Ended"
                    }
                    else{
                        let hours_f = sec / 3600
                        let minutes_f = (sec - hours! * 3600) / 60
                        let seconds_f = sec % 60
                        print("\(hours_f)")
                        endtime[i] = "\(hours_f)" + ":" + "\(minutes_f)" + ":" + "\(seconds_f)"
                    }
                    aaaaaa = aaaaaa + 1
                    //print("\(hours_f)" + ":" + "\(minutes_f)" + ":" + "\(seconds_f)")
                }
            }
            
        }
        if aaaaaa != 0{
            tableView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return id.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! tableViewCell
        cell.proname.text = name[indexPath.row]
        cell.probids.text = bids[indexPath.row]
        cell.proprice.text = price[indexPath.row]
        cell.proendtime.text = endtime[indexPath.row]
        cell.proimage.layer.borderWidth = 1
        cell.proimage.layer.masksToBounds = false
        cell.proimage.layer.borderColor = UIColor.black.cgColor
        cell.proimage.layer.cornerRadius = cell.proimage.frame.height*0.2
        cell.proimage.clipsToBounds = true
        let str = imageUrl[indexPath.row]
        let str0 = str.components(separatedBy: "_split_")
        let imgUrl = Global.imageUrl + str0[0]
        let url = URL(string: imgUrl)
        
        cell.proimage.sd_setImage(with: url, completed: nil)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        self.product_id = id[indexPath.item]
        print(id[indexPath.item])
        timer.invalidate()
        timer = nil
        self.productviewVC = self.storyboard?.instantiateViewController(withIdentifier: "productviewVC") as? ProductViewVC
        self.productviewVC.productVC = self
        self.present(self.productviewVC, animated: true, completion: nil)
        
    }
    @IBAction func gobackbtn(_ sender: Any) {
        timer.invalidate()
        timer = nil
        self.purchase = self.storyboard?.instantiateViewController(withIdentifier: "purchaseVC") as? PurchaseVC
        self.present(self.purchase, animated: true, completion: nil)
    }
    @IBAction func loginBack(_ sender: UIButton) {
        timer.invalidate()
        timer = nil
        self.loger = self.storyboard?.instantiateViewController(withIdentifier: "firstVC") as? LoginController
        self.present(self.loger, animated: true, completion: nil)
    }
    
    @IBAction func viewProfile(_ sender: UIButton) {
        timer.invalidate()
        timer = nil
        self.profile = self.storyboard?.instantiateViewController(withIdentifier: "profileVC") as? ProfileVC
        self.present(self.profile, animated: true, completion: nil)
    }
    
    @IBAction func viewHome(_ sender: UIButton) {
        timer.invalidate()
        timer = nil
        self.homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as? HomeVC
        self.present(self.homeVC, animated: true, completion: nil)
    }
    
    @IBAction func viewpurchase(_ sender: UIButton) {
        timer.invalidate()
        timer = nil
        self.purchase = self.storyboard?.instantiateViewController(withIdentifier: "purchaseVC") as? PurchaseVC
        self.present(self.purchase, animated: true, completion: nil)
    }
    @IBAction func viewWonbids(_ sender: UIButton) {
        timer.invalidate()
        timer = nil
        self.winnerVC = self.storyboard?.instantiateViewController(withIdentifier: "winnerVC") as? WinnerVC
        self.present(self.winnerVC, animated: true, completion: nil)
    }
    @IBAction func viewContact(_ sender: Any) {
        timer.invalidate()
        timer = nil
        self.contactVC = self.storyboard?.instantiateViewController(withIdentifier: "contactVC") as? ContactVC
        self.present(self.contactVC, animated: true, completion: nil)
    }
}


