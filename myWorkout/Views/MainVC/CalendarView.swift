//
//  CalendarView.swift
//  myWorkout
//
//  Created by Миша on 05.04.2022.
//

import UIKit

// ЗАМЕНИЛ НА ЗАМЫКАНИЕ!!!!!!!
//protocol SelectCalendarCollectionViewItemProtocol: AnyObject {
//    func selectItem(date: Date)
//}

class CalendarView: UIView {
    
    // MARK: - initial elements
// ЗАМЕНИЛ НА ЗАМЫКАНИЕ!!!!!!!
//    weak var calendarCollectionViewDelegate: SelectCalendarCollectionViewItemProtocol?
    var selectCollectionViewItem: ((Date)->())?
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 3 // минимальное расстояние между айтемами
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .none
        return collectionView
    }()
    
    // MARK: - life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        setupDelegates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - methods-actions
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .specialGreen
        layer.cornerRadius = 10
        addSubview(collectionView)
        
        collectionView.register(
            CalendarCollectionViewCell.self,
            forCellWithReuseIdentifier: String(describing: CalendarCollectionViewCell.self))
    }
    
    private func setupDelegates(){
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDataSource
extension CalendarView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CalendarCollectionViewCell.self),
                                                            for: indexPath) as? CalendarCollectionViewCell
        else {return UICollectionViewCell()}
        
        let currentTimeDate = Date().localDate()
        let weekDaysArray = currentTimeDate.getWeekDaysArray()
        cell.setDaysForCell(numberOfDay: weekDaysArray[1][indexPath.item],
                            dayOfWeek: weekDaysArray[0][indexPath.item])
        
        if indexPath.item == 6 {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .right)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension CalendarView: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = selectCollectionViewItem else {return}
        let dateTimeZone = Date().localDate()
        let offsetDaysArray = [6, 5, 4, 3, 2, 1, 0]
        let day = offsetDaysArray[indexPath.item]
        
        // определяем прошедшую дату для каждой ячейки, методом который в экстеншене  Date
        switch indexPath.item {
        case 0:
            selectedItem(dateTimeZone.offsetDays(days: day))
//            calendarCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 6))
        case 1:
            selectedItem(dateTimeZone.offsetDays(days: day))
//            calendarCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 5))
        case 2:
            selectedItem(dateTimeZone.offsetDays(days: day))
//            calendarCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 4))
        case 3:
            selectedItem(dateTimeZone.offsetDays(days: day))
//            calendarCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 3))
        case 4:
            selectedItem(dateTimeZone.offsetDays(days: day))
//            calendarCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 2))
        case 5:
            selectedItem(dateTimeZone.offsetDays(days: day))
//            calendarCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 1))
        case 6:
            selectedItem(dateTimeZone.offsetDays(days: day))
//            calendarCollectionViewDelegate?.selectItem(date: dateTimeZone.offsetDays(days: 0))
        default:
            break
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CalendarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width / 8,
               height: collectionView.frame.height)
    }
}

// MARK: - Constraints
extension CalendarView {
    private func setupConstraints() {
        let constraints = [
            collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 105),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
