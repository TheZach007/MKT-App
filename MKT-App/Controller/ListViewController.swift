//
//  ListViewController.swift
//  MKT-App
//
//  Created by Phincon on 25/12/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataList : [ListModel] = []
    var idData = [Int]()
    var authorData = [String]()
    var companyData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "List"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ListTableViewCell", bundle: nil), forCellReuseIdentifier: "ListTableViewCell")
        
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
        AF.request("https://jsonplaceholder.typicode.com/posts" , method: .get ,encoding: JSONEncoding.default).responseString {
                response in switch response.result {
                case .success(let data):
                    print(data)
                    
                    if let data = response.data {
                    guard let json = try? JSON(data: data) else { return }
                    print(json)
                    for (_, subJson) in json {
                        
                        let userId = subJson["userId"].int ?? 0
                        let id = subJson["id"].int ?? 0
                        let title = subJson["title"].string ?? ""
                        let body = subJson["body"].string ?? ""
                        
                        self.dataList.append(ListModel(userId: userId, id: id, title: title, body: body))
                        }
                    }
                    self.tableView.reloadData()
                        
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListTableViewCell", for: indexPath) as! ListTableViewCell
        
        cell.titleLabel.text = dataList[indexPath.row].title
        cell.bodyLabel.text = dataList[indexPath.row].body
        
        cell.authorLabel.text = authorData[dataList[indexPath.row].userId - 1]
        cell.companyLabel.text = companyData[dataList[indexPath.row].userId - 1]
        
        cell.titleLabel.sizeToFit()
        cell.bodyLabel.sizeToFit()
        cell.authorLabel.sizeToFit()
        cell.companyLabel.sizeToFit()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
        vc?.savedTitle = dataList[indexPath.row].title
        vc?.savedBody = dataList[indexPath.row].body
        vc?.savedId = dataList[indexPath.row].id
        
        navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
