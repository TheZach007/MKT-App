//
//  UserViewController.swift
//  MKT-App
//
//  Created by Phincon on 27/12/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class UserViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var phoneButton: UIButton!
    
    var dataUser : [UserModel] = []
    
    var savedUserId = 0
    var phoneNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "User"

        fetchData()
        
        nameLabel.sizeToFit()
        addressLabel.sizeToFit()
        companyLabel.sizeToFit()
    }
    
    func fetchData() {
        AF.request("https://jsonplaceholder.typicode.com/users/\(savedUserId)" , method: .get ,encoding: JSONEncoding.default).responseString {
                response in switch response.result {
                case .success(let data):
                    print(data)
                    
                    if let data = response.data {
                    guard let json = try? JSON(data: data) else { return }
                    print(json)
                    for (_) in json {
                        
                        let name = json["name"].string ?? ""
                        let street = json["address"]["street"].string ?? ""
                        let suite = json["address"]["suite"].string ?? ""
                        let city = json["address"]["city"].string ?? ""
                        let zipcode = json["address"]["zipcode"].string ?? ""
                        let company = json["company"]["name"].string ?? ""
                        let phone = json["phone"].string ?? ""
                        
                        self.nameLabel.text = name
                        self.addressLabel.text = "\(street), \(suite), \(city), \(zipcode)"
                        self.companyLabel.text = company
                        self.phoneButton.setTitle(phone, for: .normal)
                        
                        self.phoneNumber = phone
                        
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    @IBAction func phoneAction(_ sender: Any) {
        if let url = URL(string: "tel://\(phoneNumber)"),
        UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    

}
