//
//  SegmentedControl.swift
//  
//
//  Created by K Prasanna Kumar on 28/03/24.
//

import UIKit

class SegmentedControl: UIControl {

    var buttonTitles: [String] = []
    var buttons: [UIButton] = []
    var bottomBar: UIView! // Horizontal bar for selected button
    var fullBottomLine: UIView! // Full-width line at the bottom
    var bottomBarHeight: CGFloat = 2
    var fullBottomLineHeight: CGFloat = 1
    var activeButtonIndex = 0

    var activeButtonBackgroundColor: UIColor? = nil
    var inActiveButtonBackgroundColor: UIColor? = nil
    var activeButtonTextColor: UIColor? = nil
    var inActiveButtonTextColor: UIColor? = nil
    var bottomBarColor: UIColor? = nil
    var fullBottomLineColor: UIColor = .lightGray
    let tabStyle: CustomTabStyle = CustomTabStyle(
        selectedBackgroundColor: .white,
        selectedTintColor: .black,
        unselectedBackgroundColor: .white,
        unselectedTintColor: .gray,
        bottomBarColor: .blue
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        updateView()
    }
    
    func setButtonTitles(titles: [String], withActiveIndex index: Int = 0) {
        guard index < titles.count else { return }
        
        activeButtonIndex = index
        buttonTitles.removeAll()
        buttonTitles.append(contentsOf: titles)
        updateView()
    }
    
    private func updateView() {
        guard buttonTitles.count > 0 else { return }
        applyTheme()
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.setTitleColor(inActiveButtonTextColor, for: .normal)
            button.backgroundColor = inActiveButtonBackgroundColor
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            buttons.append(button)
        }
        
        buttons[activeButtonIndex].backgroundColor = activeButtonBackgroundColor
        buttons[activeButtonIndex].setTitleColor(activeButtonTextColor, for: .normal)
    }
    
    override func draw(_ rect: CGRect) {
        layer.cornerRadius = 0.0
        drawButtons()
        drawFullBottomLine()
        drawBottomBar()
    }
    
    private func drawButtons() {
        let horizontalStackView = UIStackView(arrangedSubviews: buttons)
        horizontalStackView.axis = .horizontal
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.backgroundColor = .clear
        
        addSubview(horizontalStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    private func drawFullBottomLine() {
        fullBottomLine = UIView(frame: CGRect(x: 0,
                                              y: frame.height - fullBottomLineHeight,
                                              width: frame.width,
                                              height: fullBottomLineHeight))
        fullBottomLine.backgroundColor = fullBottomLineColor
        addSubview(fullBottomLine)
    }
    
    private func drawBottomBar() {
        // whole width
        let bottomBarWidth = frame.width / CGFloat(buttons.count)
        let activeButtonXPosition = frame.width/CGFloat(buttons.count) * CGFloat(activeButtonIndex)
        bottomBar  = UIView(frame: CGRect(x: activeButtonXPosition,
                                          y: self.frame.height-bottomBarHeight,
                                          width: bottomBarWidth,
                                          height: bottomBarHeight))
        bottomBar.backgroundColor = bottomBarColor
        bottomBar.layoutMargins   = .zero
        addSubview(bottomBar)
    }
    
    private func applyTheme() {
        activeButtonBackgroundColor = tabStyle.selectedBackgroundColor
        activeButtonTextColor = tabStyle.selectedTintColor
        inActiveButtonBackgroundColor = tabStyle.unselectedBackgroundColor
        inActiveButtonTextColor = tabStyle.unselectedTintColor
        bottomBarColor = tabStyle.bottomBarColor
    }
    
    @objc private func buttonTapped(button: UIButton) {
        for (btnIndex, btn) in buttons.enumerated() {
            btn.backgroundColor = inActiveButtonBackgroundColor
            btn.setTitleColor(inActiveButtonTextColor, for: .normal)
            
            if btn == button {
                activeButtonIndex = btnIndex
                // whole width
                let activeButtonXPosition = frame.width/CGFloat(buttons.count) * CGFloat(btnIndex)
                UIView.animate(withDuration: 0.3, animations: {
                    self.bottomBar.frame.origin.x = activeButtonXPosition
                })
                btn.backgroundColor = activeButtonBackgroundColor
                btn.setTitleColor(activeButtonTextColor, for: .normal)
            }
        }
        
        sendActions(for: .valueChanged)
    }
}

struct CustomTabStyle {
    let selectedBackgroundColor: UIColor
    let selectedTintColor: UIColor
    let unselectedBackgroundColor: UIColor
    let unselectedTintColor: UIColor
    let bottomBarColor: UIColor
}
