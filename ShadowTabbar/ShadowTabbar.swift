//
//  ShadowTabbar.swift
//  ShadowTabbar
//
//  Created by Kishan Barmawala on 12/10/20.
//  Copyright © 2020 Kishan Barmawala. All rights reserved.
//

import UIKit

protocol ShadowDelegate: class {
    func shadowTabbar(didSelectAt index: Int)
}

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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ShadowTabbar: UIView {
    
    public weak var delegate : ShadowDelegate?
    private let colTabbar = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let selectionView = UIView()
    private var tabPadding : CGFloat = 8
    private var lastIdx : Int = 0
    public var numberOfTab : Int = 5
    public var preselectTab : Int = 0 {
        didSet {
            if preselectTab > numberOfTab {
                preselectTab = 0
            }
        }
    }
    public var color : [UIColor] = [.red,.green,.gray,.black,.blue]
    public var tabbarImages : [UIImage?] = [UIImage(named: "home"),UIImage(named: "heart"),UIImage(named: "message"),UIImage(named: "notification"),UIImage(named: "search")]
    private var tabbarImageInsets : CGFloat = 14
    
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
        self.selectionView.isUserInteractionEnabled = false
        self.selectionView.backgroundColor = .white
        self.backgroundColor = .clear
        self.colTabbar.bounces = false
        self.colTabbar.register(ShadowTabbarCell.self, forCellWithReuseIdentifier: "ShadowTabbarCell")
        self.colTabbar.addSubview(self.selectionView)
        self.colTabbar.isScrollEnabled = false
        self.colTabbar.dataSource = self
        self.colTabbar.delegate = self
        self.colTabbar.backgroundColor = .black
        self.addSubview(self.colTabbar)
    }
    
    func setSelectionView(view: UIView, width: CGFloat? = nil) {
        let padding : CGFloat = 8
        let calWidth = ((width ?? view.frame.width - 2) - (padding * 2)) - 8
        self.selectionView.frame = CGRect(origin: .init(x: 0, y: 2), size: .init(width: calWidth, height: 6))
        
        /*
        let scale = CGSize(width: 1.1, height: 5)
        let offsetX: CGFloat = 0
        
        let shadowPath = UIBezierPath()
        shadowPath.move(to:
            CGPoint(
                x: 0,
                y: selectionView.frame.height
            )
        )
        shadowPath.addLine(to:
            CGPoint(
                x: calWidth,
                y: selectionView.frame.height
            )
        )
        shadowPath.addLine(to:
            CGPoint(
                x: calWidth * scale.width + offsetX,
                y: selectionView.frame.height * (1 + scale.height)
            )
        )
        
        shadowPath.addLine(to:
            CGPoint(
                x: calWidth * (1 - scale.width) + offsetX,
                y: selectionView.frame.height * (1 + scale.height)
            )
        )
        selectionView.layer.shadowPath = shadowPath.cgPath
        selectionView.layer.shadowRadius = 0
        selectionView.layer.shadowOffset = .zero
        selectionView.layer.shadowOpacity = 0.175
        selectionView.layer.shadowColor = UIColor.white.cgColor
        */
        selec
        selectionView.layer.shadowRadius = 0
        selectionView.layer.shadowOffset = .zero
        selectionView.layer.shadowOpacity = 0.175
        selectionView.layer.shadowColor = UIColor.white.cgColor
        selectionView.bringSubviewToFront(colTabbar)
        self.selectionView.center.x = view.center.x
        self.selectionView.superview?.layoutIfNeeded()
    }
}

extension ShadowTabbar: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfTab
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShadowTabbarCell", for: indexPath) as! ShadowTabbarCell
        cell.btnTabbar.imageEdgeInsets = UIEdgeInsets(top: tabbarImageInsets, left: tabbarImageInsets, bottom: tabbarImageInsets, right: tabbarImageInsets)
        cell.btnTabbar.backgroundColor = .clear//color[indexPath.item]
        
        let img = tabbarImages[indexPath.item]
        let templateImage = img?.withRenderingMode(.alwaysTemplate)
        cell.btnTabbar.tintColor = .gray
        cell.btnTabbar.setImage(templateImage, for: .normal)
        
        if indexPath.item == self.preselectTab {
            cell.btnTabbar.tintColor = .white
            self.setSelectionView(view: cell/*, width: cell.btnTabbar.selectionView?.frame.width*/)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.shadowTabbar(didSelectAt: indexPath.item)
        self.lastIdx = self.preselectTab
        self.preselectTab = indexPath.item
        let previusIndex = IndexPath(item: lastIdx, section: 0)
        let currentIndex = indexPath
        guard let currentCell = self.colTabbar.cellForItem(at: currentIndex) as? ShadowTabbarCell else { return }
        if self.preselectTab == indexPath.item {
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
        return CGSize(width: self.colTabbar.bounds.width / CGFloat(self.numberOfTab) , height: colTabbar.bounds.height)
    }
}
