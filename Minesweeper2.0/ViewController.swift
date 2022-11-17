//
//  ViewController.swift
//  Minesweeper2.0
//
//  Created by Venkatram G V on 18/10/22.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var bombs: [(Int, Int)]? = nil
    var flagCount = 0
    var bombFlagged = 0
    var time = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        bombs = generateRandomBombs(size: 10)
        
        let screenWidth = collectionView.frame.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        layout.itemSize = CGSize(width: ((screenWidth / 10) - 2), height: ((screenWidth / 10) - 2))
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        collectionView.collectionViewLayout = layout
        setupLongGestureRecognizerOnCollection()
    }
    

    func generateRandomBombs(size: Int) -> [(Int, Int)]{
        
        var bombs: [(Int, Int)] = []
        let a = Array(0..<size).shuffled()
        let b = Array(0..<size).shuffled()
        for i in 0..<size{
            bombs.append((a[i],b[i]))
        }
        return bombs
    }
    
    func setupLongGestureRecognizerOnCollection() {
        let longPressedGesture = UILongPressGestureRecognizer(target: self,
                                                              action: #selector(handleLongPress(gestureRecognizer:)))
        longPressedGesture.minimumPressDuration = 0.2
        longPressedGesture.delegate = self
        longPressedGesture.delaysTouchesBegan = true
        collectionView?.addGestureRecognizer(longPressedGesture)
    }
    
    func gameOver(){
        let st = UIStoryboard(name: "Main", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "GameOver")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func revealGrid(x: Int, y:Int, cell: GridCollectionViewCell){
        for i in x-1...x+1{
            for j in y-1...y+1{
                if (i < 0 || i >= 10) || (j < 0 || j >= 10) { continue }
                let currentCell = collectionView.cellForItem(at: IndexPath(row: i, section: j)) as! GridCollectionViewCell
                if currentCell.numberCount.text == "", currentCell.isRevealed == false {
                    isbombAround(x: i, y: j, cell: currentCell)
                }
            }
        }
    }
    
    func isbombAround(x: Int, y:Int, cell: GridCollectionViewCell){
        if (!cell.isBomb) && (!cell.isflagged){
            
            cell.isRevealed = true
            var totalMine = 0
            
            for i in x-1...x+1{
                for j in y-1...y+1{
                    if (i == x && j == y) || (i < 0 || i >= 10) || (j < 0 || j >= 10) { continue }
                    let currentCell = collectionView.cellForItem(at: IndexPath(row: i, section: j)) as! GridCollectionViewCell
                    if currentCell.isBomb{
                        totalMine += 1
                    }
                }
            }
            
            if totalMine > 0{
                cell.numberCount.text = "\(totalMine)"
            }else {
                cell.backgroundColor = UIColor(named: "cell")
                revealGrid(x: x, y: y, cell: cell)
            }
            
        }
    }
    
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! GridCollectionViewCell
        for i in bombs!{
            if i == (indexPath.section, indexPath.row){
                cell.isBomb = true
                
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! GridCollectionViewCell
        if time == 0{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                print("Timer fired!")
                self.time += 1
                print(self.time)
            }
        }
        let row = indexPath.row
        let section = indexPath.section
        if (cell.isBomb) && (!cell.isflagged) {
            cell.isRevealed = true
            cell.backgroundColor = .systemRed
            cell.imgView.image = UIImage(named: "mine")
            gameOver()
        }
        isbombAround(x: row, y: section, cell: cell)
    }
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if (gestureRecognizer.state != .began) {return}
        let p = gestureRecognizer.location(in: collectionView)
        
        if let indexPath = collectionView?.indexPathForItem(at: p) {
            let cell = collectionView.cellForItem(at: indexPath) as! GridCollectionViewCell
            if (!cell.isRevealed){
                
                cell.isflagged = (!cell.isflagged)
                
                if cell.isflagged{
                    cell.imgView.image = UIImage(named: "flag")
                    flagCount += 1
                    if cell.isBomb {
                        bombFlagged += 1
                    }
                }else{
                    cell.imgView.image = nil
                    flagCount -= 1
                    if cell.isBomb {
                        bombFlagged -= 1
                    }
                }
                // print(flagCount, bombFlagged)
                
                if bombFlagged == bombs?.count && flagCount == bombs?.count{
                    print("GameOver Completed")
                    let st = UIStoryboard(name: "Main", bundle: nil)
                    let vc = st.instantiateViewController(withIdentifier: "GameCompleted")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        }
    }
    
}
