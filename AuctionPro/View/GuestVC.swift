import UIKit

class GuestVC: UIViewController {
    var avatar_url = ""
    @IBOutlet weak var avatarImg: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        avatar_url = "image/profile/default.jpg"
        let imgUrl = Global.imageUrl + avatar_url
        print(imgUrl)
        let url = URL(string: imgUrl)
        do {
            let data = try Data(contentsOf: url!)
            let image = UIImage(data: data)
            avatarImg.image = image
        }catch let err {
            print("Error : \(err.localizedDescription)")
        }
    }
}
