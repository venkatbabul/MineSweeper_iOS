//
//  GameCompletedViewController.swift
//  Minesweeper2.0
//
//  Created by Venkatram G V on 28/10/22.
//

import UIKit

class GameCompletedViewController: UIViewController {

    @IBOutlet weak var newFameButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func newGameTapped(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "ViewController")
        self.navigationController?.pushViewController(vc, animated: false)
    }
}
