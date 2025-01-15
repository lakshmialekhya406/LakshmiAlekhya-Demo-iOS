//
//  HoldingCell.swift
//  Demo
//
//  Created by Batchu Lakshmi Alekhya on 13/01/25.
//

import UIKit

class HoldingCell: UITableViewCell {
    
    static let identifier = "HoldingCell"
    
    // Create four labels
    let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    let netLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .left
        return label
    }()
    
    let ltpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    // Override initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Add labels to the content view
        contentView.addSubview(symbolLabel)
        contentView.addSubview(netLabel)
        contentView.addSubview(ltpLabel)
        contentView.addSubview(totalLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        // Enable Auto Layout
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        netLabel.translatesAutoresizingMaskIntoConstraints = false
        ltpLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Define padding
        let padding: CGFloat = 16
        
        NSLayoutConstraint.activate([
            // Left Label 1 Constraints
            symbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            symbolLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.centerXAnchor, constant: -8),
            
            // Left Label 2 Constraints
            netLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: padding),
            netLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            netLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.centerXAnchor, constant: -8),
            netLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -padding),
            
            // Right Label 1 Constraints
            ltpLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            ltpLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.centerXAnchor, constant: 8),
            ltpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            
            // Right Label 2 Constraints
            totalLabel.topAnchor.constraint(equalTo: ltpLabel.bottomAnchor, constant: padding),
            totalLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.centerXAnchor, constant: 8),
            totalLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            totalLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -padding),
        ])
    }
    
    func configure(symbol: String, quantity: Int, ltp: Double, total: Double) {
        symbolLabel.text = symbol
        netLabel.attributedText = getAttributedText(string1: "NET QTY", string2: "₹\(quantity)")
        ltpLabel.attributedText = getAttributedText(string1: "LTP", string2: "₹\(ltp.formattedWithCommas())")
        let totalColor: UIColor = total < 0 ? .red : .green
        let value: String = total < 0 ? "-₹\(abs(total).formattedWithCommas())" : "₹\(total.formattedWithCommas())"
        totalLabel.attributedText = getAttributedText(string1: "P&L", string2: value, string2Color: totalColor)
    }
    
    func getAttributedText(string1: String, string2: String, string1Color: UIColor = .gray, string2Color: UIColor = .darkGray) -> NSAttributedString {
        // Create attributes for string1
        let attributes1: [NSAttributedString.Key: Any] = [
            .foregroundColor: string1Color,
            .font: UIFont.systemFont(ofSize: 12)
        ]
        
        // Create attributes for string2
        let attributes2: [NSAttributedString.Key: Any] = [
            .foregroundColor: string2Color,
            .font: UIFont.systemFont(ofSize: 16)
        ]
        
        // Create attributed strings for string1 and string2
        let attributedString1 = NSAttributedString(string: string1, attributes: attributes1)
        let attributedString2 = NSAttributedString(string: string2, attributes: attributes2)
        
        // Combine the two attributed strings
        let combinedAttributedString = NSMutableAttributedString()
        combinedAttributedString.append(attributedString1)
        combinedAttributedString.append(NSAttributedString(string: ": ")) // Separator
        combinedAttributedString.append(attributedString2)
        
        return combinedAttributedString
    }
}
