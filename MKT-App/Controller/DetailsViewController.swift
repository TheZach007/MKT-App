//
//  DetailsViewController.swift
//  MKT-App
//
//  Created by Phincon on 27/12/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class DetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var dataComment : [CommentModel] = []
    
    var savedTitle = ""
    var savedBody = ""
    var savedId = 0
    
    var idData = [Int]()
    var authorData = [String]()
    var companyData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Details"
        titleLabel.text = "\(savedTitle)"
        bodyLabel.text = "\(savedBody)"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CommentTableViewCell", bundle: nil), forCellReuseIdentifier: "CommentTableViewCell")
        
        fetchUser()
        // Do any additional setup after loading the view.
    }
    
    func fetchUser() {
        AF.request("https://jsonplaceholder.typicode.com/users" , method: .get ,encoding: JSONEncoding.default).responseString {
                response in switch response.result {
                case .success(let data):
                    print(data)
                    
                    if let data = response.data {
                    guard let json = try? JSON(data: data) else { return }
                    print(json)
                    for (_, subJson) in json {
                        
                        let id = subJson["id"].int ?? 0
                        let name = subJson["name"].string ?? ""
                        let company = subJson["company"]["name"].string ?? ""
                        
                        self.idData.append(id)
                        self.authorData.append(name)
                        self.companyData.append(company)
                        
                        print(self.authorData)
                        
                        }
                    }
                    self.fetchData()
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    func fetchData() {
        AF.request("https://jsonplaceholder.typicode.com/posts/\(String(describing: savedId))/comments" , method: .get ,encoding: JSONEncoding.default).responseString {
                response in switch response.result {
                case .success(let data):
                    print(data)
                    
                    if let data = response.data {
                    guard let json = try? JSON(data: data) else { return }
                    print(json)
                    for (_, subJson) in json {
                        
                        let postId = subJson["postId"].int ?? 0
                        let id = subJson["id"].int ?? 0
                        let name = subJson["name"].string ?? ""
                        let email = subJson["email"].string ?? ""
                        let body = subJson["body"].string ?? ""
                        
                        self.dataComment.append(CommentModel(postId: postId, id: id, name: name, email: email, body: body))
                    }
                    self.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print(error)
                }
        }
    }

}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataComment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        
        cell.bodyLabel.text = dataComment[indexPath.row].body
        
        if dataComment.count == 0 {
            tableView.isHidden = true
        } else {
            cell.authorLabel.text = authorData[dataComment[indexPath.row].id - 1]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserViewController") as? UserViewController
        vc?.savedUserId = dataComment[indexPath.row].id
        
        navigationController?.pushViewController(vc!, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
