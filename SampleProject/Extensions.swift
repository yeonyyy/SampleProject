//
//  Extensions.swift
//  SampleProject
//
//  Created by rayeon lee on 2023/12/22.
//

import Foundation
import RxSwift
import RxCocoa

extension UIColor {
    static let backgroundColor = UIColor(red: 55, green: 55, blue: 55, alpha: 1)
}

extension String {
    func stringToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:s'Z'"
        formatter.timeZone = TimeZone(identifier: "ko_KR") as TimeZone?
        return formatter.date(from: self)!
    }
   
}

extension Date {
    func yyyyMMdd() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "ko_KR") as TimeZone?
        return formatter.string(from: self)
        
    }
    
    func yyyMMddHHmmss() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
}

extension Reactive where Base: UIViewController {
    var viewWillAppear: ControlEvent<Void> {
        let source = self.methodInvoked(#selector(Base.viewWillAppear(_:))).map { _ in }
        return ControlEvent(events: source)
    }
    
    var viewDidLoad: ControlEvent<Void> {
      let source = self.methodInvoked(#selector(Base.viewDidLoad)).map { _ in }
      return ControlEvent(events: source)
    }

}

extension Reactive where Base: UIScrollView {
    var reachedBottom: ControlEvent<Void> {
        let observable = contentOffset
            .flatMap { [weak base] contentOffset -> Observable<Void> in
                guard let scrollView = base else { return Observable.empty() }
                
                let visibleHeight = scrollView.frame.height -
                    scrollView.contentInset.top -
                    scrollView.contentInset.bottom
                let y = contentOffset.y + scrollView.contentInset.top
                let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
                
                return y > threshold ? Observable.just(()) : Observable.empty()
        }
        return ControlEvent(events: observable)
    }
}
