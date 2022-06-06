//
//  LaunchDetailViewController.swift
//  SpaceX-launches-iOS
//
//  Created by Elizeus on 05.06.2022.
//

import UIKit

class LaunchDetailViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!

    let viewModel = LaunchDetailViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
