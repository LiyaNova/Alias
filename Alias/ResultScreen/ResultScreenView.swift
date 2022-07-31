
import UIKit

//Протокол для пуша алертов
protocol PresentAlertDelegate: AnyObject {
    func presentAlert()
}

class ResultScreenView: UIView {

    weak var delegate: PresentAlertDelegate?
    var tapImageBtn: (()->())?
    private var scoreDict = ["Команда 2": 8, "Команда 3": 7]
    private var brain = BrainResultScreen()

    private let backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.image = UIImage(named: "Ellipse Background")
        return backgroundImage
    }()

     var teamLabel: UILabel = {
        let teamLabel = UILabel()
        teamLabel.translatesAutoresizingMaskIntoConstraints = false
        teamLabel.text = "КОМАНДА 1"
        teamLabel.textAlignment = .center
        teamLabel.textColor = .white
        teamLabel.font = UIFont(name: "Phosphate-Solid", size: 40)
        return teamLabel
    }()

    private var winLabel: UILabel = {
        let winLabel = UILabel()
        winLabel.translatesAutoresizingMaskIntoConstraints = false
        winLabel.text = "WIN!"
        winLabel.textAlignment = .center
        winLabel.textColor = .black
        winLabel.font = UIFont(name: "Phosphate-Solid", size: 40)
        return winLabel
    }()

     var circleLabel: UILabel = {
        let circleLabel = UILabel()
        circleLabel.translatesAutoresizingMaskIntoConstraints = false
        circleLabel.text = "10"
        circleLabel.backgroundColor = .white
        circleLabel.textAlignment = .center
        circleLabel.textColor = .black
        circleLabel.layer.masksToBounds = true
        circleLabel.layer.cornerRadius = 40
        circleLabel.font = UIFont(name: "Phosphate-Solid", size: 40)
        return circleLabel
    }()

    lazy private var cupImage: UIImageView = {
        let cupImage = UIImageView()
        cupImage.translatesAutoresizingMaskIntoConstraints = false
        cupImage.image = UIImage(named: "Goodies Appreciation")
        cupImage.isUserInteractionEnabled = true
        let tapCup = UITapGestureRecognizer(target: self, action: #selector(tapCupImage))
        cupImage.addGestureRecognizer(tapCup)
        return cupImage
    }()

    @objc private func tapCupImage() {
        
        self.tapImageBtn?()
        ResultScreenViewController().dismiss(animated: false)
       // delegate?.presentAlert()
    }

    private lazy var winStackView: UIStackView = {
        let winStackView = UIStackView(arrangedSubviews:
                                [
                                    self.teamLabel,
                                    self.winLabel,
                                    self.circleLabel,
                                    self.cupImage
                                ])
        winStackView.axis = .vertical
        winStackView.spacing = 5.0
        winStackView.alignment = .center
        winStackView.translatesAutoresizingMaskIntoConstraints = false
        return winStackView
    }()

    private lazy var resultTableView: UITableView = {
        let resultTableView = UITableView(frame: self.bounds, style: .plain)
        resultTableView.dataSource = self
        resultTableView.translatesAutoresizingMaskIntoConstraints = false
        resultTableView.register(ScoreCell.self, forCellReuseIdentifier: "ScoreCell")
        resultTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        resultTableView.delegate = self
        resultTableView.separatorStyle = .none
        resultTableView.backgroundColor = .white
        return resultTableView
    } ()

    private lazy var bottomButton: UIButton = {
       let bottomButton = UIButton()
       bottomButton.translatesAutoresizingMaskIntoConstraints = false
       bottomButton.backgroundColor = .black
       bottomButton.setTitle("Новая игра", for: .normal)
       bottomButton.titleLabel?.font = UIFont(name: "Phosphate-Solid", size: 24)
       bottomButton.titleLabel?.textColor = .white
       bottomButton.layer.cornerRadius = 16
       bottomButton.addTarget(self, action: #selector(didTapBottomButton), for: .touchUpInside)
       return bottomButton
   }()

    @objc private func didTapBottomButton() {
        print("Делегат для контроллера?А потом новая игра)")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.setViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setViews() {
        [self.backgroundImage,
         self.winStackView,
         self.resultTableView,
         self.bottomButton].forEach { self.addSubview($0)}

        NSLayoutConstraint.activate([

            self.backgroundImage.topAnchor.constraint(equalTo: self.topAnchor),
            self.backgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.backgroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            self.winStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.winStackView.bottomAnchor.constraint(equalTo: self.backgroundImage.bottomAnchor,
                                                                                     constant: -5),
            self.winStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                                                                     constant: 30),

            self.circleLabel.heightAnchor.constraint(equalToConstant: 80),
            self.circleLabel.widthAnchor.constraint(equalToConstant: 80),

            self.resultTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.resultTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.resultTableView.topAnchor.constraint(equalTo: self.backgroundImage.bottomAnchor,
                                                                                     constant: 2),
            self.resultTableView.bottomAnchor.constraint(equalTo: self.bottomButton.topAnchor,
                                                                                    constant: -10),

            self.bottomButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            self.bottomButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            self.bottomButton.heightAnchor.constraint(equalToConstant: 66),
            self.bottomButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                                                                                         constant: -11)
        ])
    }

}

//MARK: -

extension ResultScreenView: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath) as? ScoreCell
        if let cell = cell {
               // TO DO обработать колличество ячеек
            let countOfSection = indexPath.section % brain.teamName.count
            cell.myView.backgroundColor = brain.sectionColor(section: countOfSection)
            
            cell.teamLabel.text = brain.team()[indexPath.section]
            cell.scoreLabel.text = String(brain.score()[indexPath.section])
            
            cell.starImage.isHidden = brain.showStar(labelScore: cell.scoreLabel.text ?? "")

            return cell

        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66+16
    }

    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return scoreDict.count
    }

}
