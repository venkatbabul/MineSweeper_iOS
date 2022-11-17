//
//  GridCollectionViewCell.swift
//  Minesweeper2.0
//
//  Created by Venkatram G V on 18/10/22.
//

import UIKit

class GridCollectionViewCell: UICollectionViewCell {
    
    var isBomb: Bool = false
    var isflagged: Bool = false
    var isRevealed: Bool = false
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var numberCount: UILabel!
    
    
}
