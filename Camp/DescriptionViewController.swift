//
//  DescriptionViewController.swift
//  Camp
//
//  Created by NMAS Amaral on 10/04/21.
//

import Foundation
import UIKit
class DescriptionViewController: UIViewController{
    var enterprise: Enterprise!
    @IBOutlet weak var enterpriseName: UILabel!
    @IBOutlet weak var enterpriseNameCard: UILabel!
    @IBOutlet weak var descriptionEnterprise: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupData()
    }
    
    @IBAction func Back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func setupData(){
        print(enterprise.name)
        enterpriseName.text = enterprise.name
        enterpriseNameCard.text = enterprise.name
        descriptionEnterprise.text = enterprise.desc
    }
    
}
