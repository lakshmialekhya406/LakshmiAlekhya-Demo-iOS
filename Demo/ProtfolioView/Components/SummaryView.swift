//
//  SummaryView.swift
//  Demo
//
//  Created by Batchu Lakshmi Alekhya on 16/01/25.
//

import UIKit

class SummaryView: UIView {
    
    private let todayPNLLabel = UILabel()
    private let totalPNLLabel = UILabel()
    private let totalInvestmentLabel = UILabel()
    private let currentValueLabel = UILabel()
    private let topView = UIStackView()
    private let dividerView = UIView()
    
    private let currentValueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    private let totalInvestmentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    private let totalPNLStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    
    private let bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    
    private let parentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    private let currentValueTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.text = "Current Value*"
        return label
    }()
    
    private let totalInvestmentTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.text = "Total Investment*"
        return label
    }()
    private let todayPNLTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .left
        label.text = "Today's Profit & Loss*"
        return label
    }()
    
    private let totalPNLButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        button.setTitle("Profit & Loss*", for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
        button.setImage(UIImage(systemName: "chevron.up.circle.fill"), for: .normal)
        button.tintColor = .darkGray
        button.setPreferredSymbolConfiguration(.unspecified, forImageIn: .normal)
        return button
    }()
    
    private var isExpanded: Bool = false
    var onDropdownTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 16
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.masksToBounds = true
        self.backgroundColor = .lightGray.withAlphaComponent(0.4)
    }
    
    private func setupUI() {
        // Configure labels
        configureLabel(todayPNLLabel)
        configureLabel(totalPNLLabel)
        configureLabel(totalInvestmentLabel)
        configureLabel(currentValueLabel)
        
        currentValueStackView.addArrangedSubview(currentValueTitleLabel)
        currentValueStackView.addArrangedSubview(currentValueLabel)
        
        totalInvestmentStackView.addArrangedSubview(totalInvestmentTitleLabel)
        totalInvestmentStackView.addArrangedSubview(totalInvestmentLabel)
        
        totalPNLStackView.addArrangedSubview(todayPNLTitleLabel)
        totalPNLStackView.addArrangedSubview(todayPNLLabel)
        
        // Configure top stack view
        topView.axis = .vertical
        topView.spacing = 16
        topView.isHidden = true
        topView.addArrangedSubview(currentValueStackView)
        topView.addArrangedSubview(totalInvestmentStackView)
        topView.addArrangedSubview(totalPNLStackView)
        topView.backgroundColor = .clear
        
        
        // Configure divider view
        dividerView.backgroundColor = .lightGray
        dividerView.isHidden = true
        
        // Configure bottom stack view
        totalPNLButton.addTarget(self, action: #selector(expandAction(_:)), for: .touchUpInside)
        bottomStackView.addArrangedSubview(totalPNLButton)
        bottomStackView.addArrangedSubview(totalPNLLabel)
        
        parentStackView.addArrangedSubview(topView)
        parentStackView.addArrangedSubview(dividerView)
        parentStackView.addArrangedSubview(bottomStackView)
        addSubview(parentStackView)
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        self.addGestureRecognizer(tapGesture)
        
        // Layout using Auto Layout
        setupConstraints()
    }
    
    private func setupConstraints() {
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        parentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            parentStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            parentStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            parentStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            parentStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
            ])
    }
    
    private func configureLabel(_ label: UILabel) {
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 1
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
    
    @objc private func expandAction(_ sender: UIButton) {
        viewTapped()
    }
    
    @objc private func viewTapped() {
        isExpanded.toggle()
        topView.isHidden = !isExpanded
        dividerView.isHidden = !isExpanded
        let chevImage = isExpanded ? UIImage(systemName: "chevron.down.circle.fill") : UIImage(systemName: "chevron.up.circle.fill")
        totalPNLButton.setImage(chevImage, for: .normal)
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
