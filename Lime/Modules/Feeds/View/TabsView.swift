//
//  TabsView.swift
//  Lime
//
//  Created by Vadim Presnov on 27.01.2023.
//

import UIKit

protocol CollectionDidScrollDelegate: AnyObject {
    func collectionViewDidScroll(progress: CGFloat, ratio: CGFloat)
    func didEndScroll()
}

protocol TabsScrollDelegate: AnyObject{
    func didIndexChanged(at index: Int, animated: Bool)
}

final class TabsView: UIView {
    // MARK: - Properties
    private var titles: [String] = []
    private var labels: [UILabel] = []
    
    private(set) var selectedIndex = 0 {
        didSet {
            tabsDelegate?.didIndexChanged(at: self.selectedIndex, animated: true)
        }
    }
    
    private var textColor: UIColor = .white
    private var selectedTextColor: UIColor = .white
    private var bottomSelectedLineHeight: CGFloat = 0
    private var scroll: CGFloat = 0
    private var extraBottomSpace: CGFloat = 6
    
    private var selectorView = UIView()
    private let scrollView = UIScrollView()
    private var stackView = UIStackView()
    private let bottomSeparatorView = UIView()
    private var isSelected = false
    
    weak var tabsDelegate: TabsScrollDelegate?
    
    //MARK: - Life cycle
    convenience init(
        titles: [String],
        textColor: UIColor,
        selectedTextColor: UIColor,
        bottomSelectedLineHeight: CGFloat
    ) {
        self.init(frame: .zero)
        self.textColor = textColor
        self.selectedTextColor = selectedTextColor
        self.bottomSelectedLineHeight = bottomSelectedLineHeight
        self.titles = titles
        updateView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        selectorView.frame.origin.y = scrollView.frame.maxY - bottomSelectedLineHeight - extraBottomSpace
    }

    // MARK: - Helpers
    private func updateView() {
        createLabels()
        setupStackView()
        setupBottomSeparatorView()
    }
    
    private func createLabels() {
        labels.removeAll()
        subviews.forEach({ $0.removeFromSuperview() })
        for labelTitle in titles {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            label.text = labelTitle
            let tapGestureRecognizor = UITapGestureRecognizer(target: self, action: #selector(labelActionHandler(sender:)))
            tapGestureRecognizor.numberOfTapsRequired = 1
            label.addGestureRecognizer(tapGestureRecognizor)
            label.isUserInteractionEnabled = true
            label.textColor = textColor
            label.textAlignment = .center
            labels.append(label)
        }
        labels[0].textColor = selectedTextColor
    }
    
    private func setupStackView() {
        stackView = UIStackView(arrangedSubviews: labels)
        scrollView.showsHorizontalScrollIndicator = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 40
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 40),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20),
            
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
        
        scrollView.layoutIfNeeded()
        selectorView = UIView(
            frame: CGRect(
                x: labels[0].frame.minX + 40 - 12,
                y: scrollView.frame.maxY - bottomSelectedLineHeight,
                width: labels[0].frame.width + 24,
                height: bottomSelectedLineHeight
            )
        )
        selectorView.backgroundColor = UIColor(hexString: "0077FF")
        selectorView.layer.cornerRadius = 6
        selectorView.clipsToBounds = true
        scrollView.addSubview(selectorView)
        scrollView.sendSubviewToBack(selectorView)
        
        scrollView.delegate = self
    }
    
    private func setupBottomSeparatorView() {
        addSubview(bottomSeparatorView)
        bottomSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomSeparatorView.heightAnchor.constraint(equalToConstant: 0.5),
            bottomSeparatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomSeparatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomSeparatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        bottomSeparatorView.backgroundColor = UIColor(hexString: "4A4C50")
    }
    
    @objc
    private func labelActionHandler(sender:UITapGestureRecognizer) {
        for (labelIndex, lbl) in labels.enumerated() {
            if lbl == sender.view{
                labels[selectedIndex].textColor = textColor
                selectedIndex = labelIndex
                labels[selectedIndex].textColor = selectedTextColor
                let current = labels[selectedIndex].frame
                isSelected = true
                let position = min(current.origin.x, max(scrollView.contentSize.width - scrollView.bounds.width,0))
                tabsDelegate?.didIndexChanged(at: selectedIndex, animated: true)
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.scrollView.contentOffset.x = position
                    self?.selectorView.frame.origin.x = current.origin.x + 40 - 12
                    self?.selectorView.frame.size.width = current.width + 24
                }
                completion: { [weak self] _ in
                    self?.isSelected = false
                }
             }
         }
     }
    
    private func calculateScrollPosition(ratio: CGFloat, reverse: Bool) {
        scroll = scroll == 0 ? scrollView.contentOffset.x : scroll
        if reverse {
            let current = labels[selectedIndex].frame
            let next = (selectedIndex < labels.count - 1) ? labels[selectedIndex + 1].frame : current

            if scrollView.contentOffset.x > next.origin.x {
                scrollView.contentOffset.x = min(
                    scroll - (scroll - next.origin.x) * ratio,
                    max(scrollView.contentSize.width - scrollView.bounds.width, 0)
                )
            } else if scrollView.contentOffset.x < next.origin.x {
                scrollView.contentOffset.x = min(
                    scroll + max((next.origin.x - scroll) * ratio, 1),
                    max(scrollView.contentSize.width - scrollView.bounds.width, 0)
                )
            }
            selectorView.frame.origin.x = current.origin.x + (next.origin.x - current.origin.x) * ratio + 40 - 12
            selectorView.frame.size.width = current.size.width + (next.size.width - current.size.width) * ratio + 24
            labels[selectedIndex].textColor = selectedTextColor.convert(to: textColor, multiplier: ratio)
            if (selectedIndex < labels.count - 1) {
                labels[selectedIndex + 1].textColor = textColor.convert(to: selectedTextColor, multiplier: ratio)
            }
        } else {
            let current = labels[selectedIndex].frame
            let next = selectedIndex > 0 ? labels[selectedIndex - 1].frame : current
            if scrollView.contentOffset.x > next.origin.x {

                scrollView.contentOffset.x = min(
                    next.origin.x + (scroll - next.origin.x) * ratio,
                    max(scrollView.contentSize.width - scrollView.bounds.width, 0)
                )
            } else
            if scrollView.contentOffset.x < next.origin.x {
                scrollView.contentOffset.x = min(
                    next.origin.x - (next.origin.x - scroll) * ratio,
                    max(scrollView.contentSize.width - scrollView.bounds.width, 0)
                )
            }
            selectorView.frame.origin.x = next.origin.x + (current.origin.x - next.origin.x) * ratio + 40 - 12
            selectorView.frame.size.width = next.size.width + (current.size.width - next.size.width) * ratio + 24
            labels[selectedIndex].textColor = textColor.convert(to: selectedTextColor, multiplier: ratio)
            if selectedIndex > 0 {
                labels[selectedIndex - 1].textColor = selectedTextColor.convert(to: textColor, multiplier: ratio)
            }
        }
    }
}

// MARK: - CollectionDidScrollDelegate
extension TabsView: CollectionDidScrollDelegate {
    func collectionViewDidScroll(progress: CGFloat, ratio: CGFloat) {
        if progress >= frame.width * CGFloat(selectedIndex + 1) {
            scroll = 0
            if !isSelected {
                selectedIndex = selectedIndex + 1
            }
        } else if progress <= frame.width * CGFloat(selectedIndex - 1) {
            scroll = 0
            if !isSelected {
                selectedIndex = selectedIndex - 1
            }
        }
        if !isSelected {
            switch progress {
            case let offset where offset > frame.width * CGFloat(selectedIndex):
                calculateScrollPosition(ratio: ratio, reverse: true)
            case let offset where offset < frame.width * CGFloat(selectedIndex):
                calculateScrollPosition(ratio: ratio, reverse: false)
            default:
                scroll = 0
            }
        }
    }

    func didEndScroll() {
        isSelected = false
        UIView.animate(withDuration: 0.2) {
            let current = self.labels[self.selectedIndex].frame
            let position = min(current.origin.x, max(self.scrollView.contentSize.width - self.scrollView.bounds.width,0))
            self.scrollView.contentOffset.x = position
            self.selectorView.frame.origin.x = current.minX + 40 - 12
            self.selectorView.frame.size.width = current.width + 24
        }
    }

    func changeSelectorViewFrameTo(index: Int, lastIndex: Int) {
        if index < labels.count, index >= 0,
           lastIndex < labels.count, lastIndex >= 0 {
            let current = labels[index].frame
            let position = min(current.origin.x, max(self.scrollView.contentSize.width - scrollView.bounds.width,0))
            scrollView.contentOffset.x = position
            selectorView.frame.origin.x = current.minX + 40 - 12
            selectorView.frame.size.width = current.width + 24
            labels[index].textColor = selectedTextColor.convert(to: textColor, multiplier: 0)
            labels[lastIndex].textColor = selectedTextColor.convert(to: textColor, multiplier: 1)
        }
    }
}

// MARK: - ScrollViewDelegate
extension TabsView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scroll = 0
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scroll = 0
    }
}
