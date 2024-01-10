//
//  BoardsSearchCellModel.swift
//  SampleProject
//
//  Created by rayeon lee on 2023/12/24.
//

import Foundation
import UIKit

class BoardsSearchCellModel {
    var lefImage: UIImage? = nil
    var category: String
    var keyword: String
    var rightImage: UIImage? = nil
    
    var hidesLeftImage: Bool
    var history: History? = nil
    
    init(history: History) {
        self.history = history
        self.hidesLeftImage = false
        self.lefImage = UIImage(systemName: "clock.arrow.circlepath")
        self.category = history.category
        self.keyword = history.keyword
        self.rightImage = UIImage(systemName: "xmark")
    }
    
    init(category: String, keyword: String) {
        self.hidesLeftImage = true
        self.category = category
        self.keyword = keyword
        self.rightImage = UIImage(systemName: "chevron.right")
    }
    
}
