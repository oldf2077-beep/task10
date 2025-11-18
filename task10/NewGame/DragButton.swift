//
//  DragButton.swift
//  task10
//
//  Created by akote on 7.11.25.
//

import UIKit

class DragButton: UIButton {
    var dragHandler: ((UILongPressGestureRecognizer) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDragGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDragGesture()
    }
    
    private func setupDragGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.3
        self.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        dragHandler?(gesture)
    }
}
