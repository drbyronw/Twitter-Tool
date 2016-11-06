//
//  MenuViewController.swift
//  Twitter-Tool
//
//  Created by Byron J. Williams on 11/5/16.
//  Copyright © 2016 Byron J. Williams. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let menuTitles = ["Your Profile", "Timeline", "Mentions"]
    private var tweetsViewController: UIViewController!
    private var profileViewController: UIViewController!
    private var mentionsViewController: UIViewController!
    
    var hamburgerViewController: HamburgerViewController!
    
    var viewControllers: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        tweetsViewController = storyboard.instantiateViewController(withIdentifier: "TweetsVC")
        profileViewController = storyboard.instantiateViewController(withIdentifier: "ProfileVC")
        mentionsViewController = storyboard.instantiateViewController(withIdentifier: "MentionsVC")
        
        viewControllers.append(tweetsViewController)
        viewControllers.append(profileViewController)
        viewControllers.append(mentionsViewController)
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        cell.menuLabel.text = menuTitles[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuTitles.count 
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
