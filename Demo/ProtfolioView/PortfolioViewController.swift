//
//  PortfolioViewController.swift
//  Demo
//
//  Created by Batchu Lakshmi Alekhya on 13/01/25.
//

import UIKit
import Combine

class PortfolioViewController: UIViewController {
    
    // UI Components
    private let customSegmentedControl = SegmentedControl()
    private let tableView = UITableView()
    private let expandableView = SummView()
    
    private var expandableViewHeightConstraint: NSLayoutConstraint!
    private var isExpanded = false // Tracks the state of expandable view
    
    private var currentSegment: Int = 1 // Tracks the selected segment
    var viewModel: PortfolioVM!
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // Configure UI Components
        configureSegmentedControl()
        configureTableView()
        configureExpandableView()
        
        // Layout UI components
        layoutUI()
        
        // Observe loading and error states
        observeViewModel()
        
        title = "Portfolio"
    }
    
    // MARK: - UI Configuration
    
    private func configureSegmentedControl() {
        customSegmentedControl.setButtonTitles(titles: ["POSITIONS", "HOLDINGS"], withActiveIndex: currentSegment)
        customSegmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        customSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customSegmentedControl)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(HoldingCell.self, forCellReuseIdentifier: HoldingCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }
    
    private func configureExpandableView() {
        expandableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(expandableView)
        expandableView.onDropdownTapped = {
            self.expandableViewTapped()
        }
        expandableView.configureData(currentValue: viewModel.currentValue, totalInvestment: viewModel.totalInvestment, totalPNL: viewModel.totalPNL, todaysPNL: viewModel.todaysPNL)
    }
    
    private func layoutUI() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Layout constraints for UI components
        NSLayoutConstraint.activate([
            // Center the activity indicator in the view
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            // Layout for custom segmented control
            customSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            customSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customSegmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            // Layout for table view
            tableView.topAnchor.constraint(equalTo: customSegmentedControl.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Table view bottom anchor tied to expandable view
            tableView.bottomAnchor.constraint(equalTo: expandableView.topAnchor)
        ])
        
        // Layout for expandable view
        expandableViewHeightConstraint = expandableView.heightAnchor.constraint(equalToConstant: 80) // Initial height
        NSLayoutConstraint.activate([
            expandableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expandableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            expandableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -6),
            expandableViewHeightConstraint
        ])
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func updateUI() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.expandableView.configureData(currentValue: self?.viewModel.currentValue ?? 0.0, totalInvestment: self?.viewModel.totalInvestment ?? 0.0, totalPNL: self?.viewModel.totalPNL ?? 0.0, todaysPNL: self?.viewModel.todaysPNL ?? 0.0)
        }
    }
    
    // MARK: - Observers
    private func observeViewModel() {
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                    self?.updateUI()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                if let message = errorMessage {
                    self?.showErrorAlert(message: message)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    
    @objc private func segmentChanged(_ sender: SegmentedControl) {
        currentSegment = sender.activeButtonIndex
        tableView.reloadData() // Reload the table view when the segment changes
    }
    
    private func expandableViewTapped() {
        // Toggle the state of the expandable view
        isExpanded.toggle()
        
        // Update the height constraint
        let newHeight: CGFloat = isExpanded ? 200 : 80
        
        UIView.animate(withDuration: 0.3, animations: {
            self.expandableViewHeightConstraint.constant = newHeight
            self.view.layoutIfNeeded() // Animate the layout change
        })
    }
}

extension PortfolioViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.holdings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HoldingCell.identifier, for: indexPath) as? HoldingCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        let data = viewModel.holdings[indexPath.row]
        let total = (data.ltp * Double(data.quantity)) - (data.avgPrice * Double(data.quantity))
        cell.configure(symbol: data.symbol, quantity: data.quantity, ltp: data.ltp, total: total)
        return cell
    }
}
