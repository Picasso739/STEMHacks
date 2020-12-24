//
//  ViewController.swift
//  STEMHacks
//
//  Created by Ethan Miller on 9/22/20.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //ui variables
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var headerStackView: UIStackView!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var mailButton: UIButton!
    
    @IBOutlet weak var mainSelector: UISegmentedControl!
    
    @IBOutlet weak var contentTableView: UITableView!
    
    //function to actiavte when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //function to activate when the menu button is pressed
    @IBAction func menuButton(_ sender: UIButton) {
        
    }
    
    //function to activate when the mail button is pressed
    @IBAction func mailButton(_ sender: UIButton) {
        
    }
    
    //function to return the number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    //function to activate to add a view for each cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80))
        
        return cell
    }

}

