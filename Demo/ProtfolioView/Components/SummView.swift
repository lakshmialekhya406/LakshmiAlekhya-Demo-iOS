//
//  SummView.swift
//  Demo
//
//  Created by Batchu Lakshmi Alekhya on 14/01/25.
//

import UIKit

class SummView: UIView {
    
    @IBOutlet weak var todayPNLLabel: UILabel!
    @IBOutlet weak var totalPNLLabel: UILabel!
    @IBOutlet weak var totalInvestmentLabel: UILabel!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var topView: UIStackView!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var dividerView: UIView!
    var isExpanded: Bool = false
    var onDropdownTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 16 // Adjust the radius as needed
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Top left and top right
        self.layer.masksToBounds = true
        self.backgroundColor = .darkGray
    }
    
    private func commonInit() {
        // Load the XIB
        let nib = UINib(nibName: "SummView", bundle: nil)
        guard let contentView = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
        topView.isHidden = true
        dividerView.isHidden = true
    }
    
    func configureData(currentValue: Double, totalInvestment: Double, totalPNL: Double, todaysPNL: Double) {
        setLabel(label: currentValueLabel, value: currentValue)
        setLabel(label: totalInvestmentLabel, value: totalInvestment)
        setLabel(label: totalPNLLabel, value: totalPNL)
        setLabel(label: todayPNLLabel, value: todaysPNL)
    }
    
    private func setLabel(label: UILabel, value: Double) {
        if value < 0 {
            label.textColor = .red
        } else {
            label.textColor = .darkGray
        }
        label.text = value < 0 ? "-₹\(abs(value).formattedWithCommas())" : "₹\(value.formattedWithCommas())"
    }
    
    @IBAction func expandAction(_ sender: UIButton) {
        isExpanded.toggle()
        topView.isHidden = !isExpanded
        dividerView.isHidden = !isExpanded
        let chevImage = isExpanded ? UIImage(systemName: "chevron.down.circle.fill") : UIImage(systemName: "chevron.up.circle.fill")
        expandButton.setImage(chevImage, for: .normal)
        onDropdownTapped?()
    }
}

extension Double {
    func formattedWithCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        return numberFormatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
