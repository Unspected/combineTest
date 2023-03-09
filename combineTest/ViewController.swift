//
//  ViewController.swift
//  combineTest
//
//  Created by Pavel Andreev on 3/8/23.
//

import UIKit
import Combine

class MyTableViewCell: UITableViewCell {
    
    private let button: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemPink
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let action = PassthroughSubject<String,Never>()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(button)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonPressed() {
        action.send("Cool Button Was tapped!")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 10, y: 5, width: contentView.frame.size.width - 20 ,
                              height: contentView.frame.size.height - 6)
    }
    
}

class ViewController: UIViewController {
    
    private let tableView: UITableView = {
       let table = UITableView()
       table.register(MyTableViewCell.self,
                       forCellReuseIdentifier: "cell")
       return table
    }()
    
    private var models = [String]()
    
    var observers: [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        APIcaller.shared.fetchCompanies()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        print("finished")
                    case .failure(let error):
                        print(error)
                }
        },
            receiveValue: { [weak self] value in
                self?.models = value
                self?.tableView.reloadData()
            }).store(in: &observers)
        
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyTableViewCell else {
            return UITableViewCell()
        }
       // cell.textLabel?.text = models[indexPath.row]
        cell.action.sink { string in
            print(string)
        }.store(in: &observers)
        return cell
    }
    
    
    
}
