//
//  ShadowTabbar.swift
//  ShadowTabbar
//
//  Created by Kishan Barmawala on 12/10/20.
//  Copyright © 2020 Kishan Barmawala. All rights reserved.
//

import UIKit

protocol ShadowDelegate: class { func shadowTabbar(didSelectAt index: Int) }

class ShadowTabbarCell : UICollectionViewCell {
    let btnTabbar = UIButton()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addViews()
    }
    func addViews() {
        self.btnTabbar.translatesAutoresizingMaskIntoConstraints = false
        self.btnTabbar.imageView?.contentMode = .scaleAspectFit
        self.btnTabbar.isUserInteractionEnabled = false
        self.addSubview(btnTabbar)
        NSLayoutConstraint.activate([
            self.btnTabbar.topAnchor.constraint(equalTo: topAnchor),
            self.btnTabbar.leadingAnchor.constraint(equalTo: leadingAnchor),
            self.btnTabbar.bottomAnchor.constraint(equalTo: bottomAnchor),
            self.btnTabbar.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

class ShadowTabbar: UIView {
    
    private let colTabbar = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var tabbarImageInsets : CGFloat = 14
    private var tabPadding : CGFloat = 8
    private let selectionLineView = UIView()
    private let padding : CGFloat = 8
    private var lastIdx : Int = 0
    public weak var delegate : ShadowDelegate?
    public var numberOfTabs : Int = 5
    public var preselectTabIdx : Int = 0 {
        didSet {
            if preselectTabIdx > numberOfTabs {
                preselectTabIdx = 0
            }
        }
    }
//    public var tabbarImages : [UIImage?] = [UIImage(named: "home"),UIImage(named: "heart"),UIImage(named: "message"),UIImage(named: "notification"),UIImage(named: "search")]
    public var tabbarImages : [UIImage?] = [nil,nil,nil,nil,nil]
    
    override func draw(_ rect: CGRect) {
        self.colTabbar.frame = rect.insetBy(dx: tabPadding, dy: 4)
        self.colTabbar.layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    func setupUI() {
        self.selectionLineView.isUserInteractionEnabled = false
        self.selectionLineView.backgroundColor = .white
        self.selectionLineView.layer.shadowRadius = 4
        self.selectionLineView.layer.shadowOffset = .init(width: 0, height: 2)
        self.selectionLineView.layer.shadowOpacity = 0.8
        self.selectionLineView.layer.shadowColor = UIColor.white.cgColor
        self.selectionLineView.bringSubviewToFront(colTabbar)
        
        self.backgroundColor = .clear
        self.colTabbar.bounces = false
        self.colTabbar.register(ShadowTabbarCell.self, forCellWithReuseIdentifier: "ShadowTabbarCell")
        self.colTabbar.addSubview(self.selectionLineView)
        self.colTabbar.isScrollEnabled = false
        self.colTabbar.dataSource = self
        self.colTabbar.delegate = self
        self.colTabbar.backgroundColor = .black
        self.addSubview(self.colTabbar)
    }
    
    func setSelectionView(view: UIView, width: CGFloat? = nil) {
        let calWidth = ((width ?? view.frame.width - 2) - (padding * 2)) - 8
        self.selectionLineView.frame = CGRect(origin: .init(x: 0, y: 2), size: .init(width: calWidth, height: 4))
        self.selectionLineView.center.x = view.center.x
        self.selectionLineView.superview?.layoutIfNeeded()
    }
}

extension ShadowTabbar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfTabs
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShadowTabbarCell", for: indexPath) as! ShadowTabbarCell
        cell.btnTabbar.imageEdgeInsets = UIEdgeInsets(top: tabbarImageInsets, left: tabbarImageInsets, bottom: tabbarImageInsets, right: tabbarImageInsets)
        cell.btnTabbar.backgroundColor = .clear
        
        let img = tabbarImages[indexPath.item]
        let templateImage = img?.withRenderingMode(.alwaysTemplate)
        cell.btnTabbar.tintColor = .gray
        cell.btnTabbar.setImage(templateImage, for: .normal)
        
        if indexPath.item == self.preselectTabIdx {
            cell.btnTabbar.tintColor = .white
            self.setSelectionView(view: cell/*, width: cell.btnTabbar.selectionView?.frame.width*/)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.shadowTabbar(didSelectAt: indexPath.item)
        self.lastIdx = self.preselectTabIdx
        self.preselectTabIdx = indexPath.item
        let previusIndex = IndexPath(item: lastIdx, section: 0)
        let currentIndex = indexPath
        guard let currentCell = self.colTabbar.cellForItem(at: currentIndex) as? ShadowTabbarCell else { return }
        if self.preselectTabIdx == indexPath.item {
            UIView.animate(withDuration: 0.3, animations: {
                self.setSelectionView(view: currentCell)
            })
        }
        if self.lastIdx != indexPath.item {
        self.colTabbar.reloadItems(at: [previusIndex,currentIndex])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.colTabbar.bounds.width / CGFloat(self.numberOfTabs) , height: colTabbar.bounds.height)
    }
}
