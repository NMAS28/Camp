//
//  CompaniesViewController.swift
//  Camp
//
//  Created by NMAS Amaral on 04/04/21.
//

import Foundation
import Alamofire
import UIKit
class CompaniesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var token: String!
    var client: String!
    var uid: String!
    var enterprisesArray:[Enterprise] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var search: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getCompanies()
    }
    func getCompanies(){
        enterprisesArray.removeAll()
        let headers: HTTPHeaders = ["access-token":self.token, "client":self.client, "uid":self.uid]
        var url: String?
        if !search.text!.isEmpty{
            url = "https://empresas.ioasys.com.br/api/v1/enterprises?name=" + search.text!
        }
        else{
            url = "https://empresas.ioasys.com.br/api/v1/enterprises"
        }
        AF.request(URL(string: url!)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON{response in
            switch response.result{
            case let .success(value):
                let object = value as AnyObject
                print(object["enterprises"])
                if let enterprises = object["enterprises"] as?[[String:Any]]{
                    for enterprise in enterprises{
                        var myEnterprise = Enterprise(id:(enterprise["id"] as? Int)! , name: (enterprise["enterprise_name"] as? String)!, desc: (enterprise["description"] as? String)!)
                        self.enterprisesArray.append(myEnterprise)
                    }
                }
            case let .failure(error):
                print("aqui")
                print(error)
                print("aqui")
            }
            self.tableView.reloadData()
        }
        
    }
    @IBAction func searched(_ sender: Any) {
        getCompanies()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enterprisesArray.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = UITableViewCell()
            cell.textLabel?.text = "\(enterprisesArray.count) Resultados encontrados"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 11)
            cell.textLabel?.textColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0)
            return cell
        }
        if !self.enterprisesArray.isEmpty{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellEnterprise", for: indexPath) as? EnterpriseTableViewCell
            cell?.enterpriseLabel.text = enterprisesArray[indexPath.row-1].name
            cell?.enterpriseView.backgroundColor = UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1.0)
            return cell!
        }
        else{
            return UITableViewCell()
        }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 40
        }
        return 170
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let descriptionvc = storyBoard.instantiateViewController(identifier: "DescriptionvcID")as? DescriptionViewController{
            descriptionvc.enterprise = self.enterprisesArray[indexPath.row+1]
            descriptionvc.modalPresentationStyle = .fullScreen
            self.present(descriptionvc, animated: true, completion: nil)
        }
    }
}



