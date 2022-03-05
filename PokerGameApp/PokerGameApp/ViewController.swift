//
//  ViewController.swift
//  PokerGameApp
//
//  Created by 백상휘 on 2022/02/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var logTextView: UITextView!
    @IBOutlet weak var screenView: UIView!
    
    private var cards: [UIImageView]!
    private var endOfRange: UITextRange? {
        logTextView.textRange(from: logTextView.endOfDocument, to: logTextView.endOfDocument)
    }
    
    private let poker = PokerGame(of: TypeOfGame.SevenStudPoker)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logTextView.delegate = self
        
        if let bgPattern = UIImage.init(named: "bg_pattern") {
            self.view.backgroundColor = UIColor.init(patternImage: bgPattern)
        }
        
        startAndResetGame()
    }
    
    func startAndResetGame() {
        
        if let shuffleCountDealerWant = (1...5).randomElement() {
            for _ in 1...shuffleCountDealerWant {
                poker.shuffleAll()
            }
        }
        poker.drawCardsToAllMembers()
        
        for i in 0..<poker.participantCount.rawValue {
            if let cards = poker.getParticipant(at: i)?.getCards() {
                setPersonGameInfo(of: cards, playerName: "Player \(i)")
            }
        }
        
        setPersonGameInfo(of: poker.dealerCards(), playerName: "Dealer")
    }
    
    func setPersonGameInfo(of cards: [Card], playerName: String) {
        
        let stackView = UIStackView(arrangedSubviews: cards.getImageViews())
        let label = UILabel()
        label.text = playerName
        
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = 3
        
        defineLayoutOfCardView(label: label, stackView: stackView)
//        defineAutoResizingCardView(label: label, stackView: stackView)
    }
    
    private func defineAutoResizingCardView(label: UILabel, stackView: UIStackView) {
        
        var lastSubViewBottomOrigin: CGPoint {
            CGPoint(x: 0, y: (screenView.subviews.last?.frame.maxY ?? 0))
        }
        var cardWidth: CGFloat {
            (screenView.frame.width / CGFloat(poker.typeOfGame.cardCount)) - 3
        }
        var superViewSize = screenView.frame.size
        
        superViewSize.height = 18
        screenView.addSubview(label)
        label.frame = CGRect(origin: lastSubViewBottomOrigin, size: superViewSize)
        
        superViewSize.height = cardWidth*1.27
        screenView.addSubview(stackView)
        stackView.frame = CGRect(origin: lastSubViewBottomOrigin, size: superViewSize)
        
        screenView.layoutSubviews()
    }
    
    private func defineLayoutOfCardView(label: UILabel, stackView: UIStackView) {
        
        let anchor = screenView.subviews.last == nil ? screenView.topAnchor : screenView.subviews.last!.bottomAnchor
        
        screenView.insertSubview(label, at: screenView.subviews.count)
        label.translatesAutoresizingMaskIntoConstraints = false // make autoresizie do not interfere autolayout.
        
        label.leadingAnchor.constraint(equalTo: screenView.leadingAnchor, constant: 8).isActive = true
        label.topAnchor.constraint(equalTo: anchor, constant: 0).isActive = true
        label.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        let cardCount = poker.typeOfGame.cardCount
        var cardWidth: CGFloat {
            (screenView.frame.width / CGFloat(cardCount)) - 3
        }
        
        screenView.insertSubview(stackView, at: screenView.subviews.count)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.leadingAnchor.constraint(equalTo: screenView.leadingAnchor, constant: 8).isActive = true
        stackView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 3).isActive = true
        stackView.trailingAnchor.constraint(equalTo: screenView.trailingAnchor, constant: -8).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: cardWidth*1.27).isActive = true
        
        // 시스템에 subviews 들의 layout을 업데이트 하라는 명령을 내림. Update Cycle을 기다리므로 성능에 좋은 영향을 줄 것으로 예상.
        screenView.setNeedsLayout()
    }
    
    private func alert(with message: String) {
        UIAlertController.alert(with: "값은 아래와 같습니다", at: self)
    }
    
    private func setLog(text: String) {
        if let endOfRange = logTextView.textRange(from: logTextView.endOfDocument, to: logTextView.endOfDocument) {
            logTextView.replace(endOfRange, withText: text)
        }
    }
}

extension UIAlertController {
    static func alert(with title: String, at viewController: UIViewController, cancelMessage: String? = nil) {
        let alert = UIAlertController.init(title: title, message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: cancelMessage ?? "닫기", style: .destructive) { _ in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        
        viewController.show(alert, sender: nil)
    }
}

extension ViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        textView.text += "\n"
        
        textView.scrollRectToVisible(
            CGRect(origin: textView.contentOffset, size: textView.contentSize),
            animated: true
        )
    }
}

enum TypeOfGame {
    case SevenStudPoker
    case FiveStudPoker
    
    var cardCount: Int {
        switch self {
        case .SevenStudPoker:
            return 7
        case .FiveStudPoker:
            return 5
        }
    }
}

extension Array where Element == Card {
    func getImageViews() -> [UIImageView] {
        return self.compactMap {
            let imageView = UIImageView(image: UIImage(named: $0.getImageName()))
            imageView.contentMode = .scaleAspectFit
            return imageView
        }
    }
}
