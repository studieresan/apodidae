//
//  StudsButton.swift
//  Studs
//
//  Created by Willy Liu on 2019-03-02.
//  Copyright © 2019 Studieresan. All rights reserved.
//

import UIKit

class StudsButton: UIButton {

    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .primaryDark : .primary
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel?.textColor = .white
        layer.cornerRadius = 20
        clipsToBounds = true
        backgroundColor = .primary
    }

}
