//
//  ImageWidget.swift
//  RxSwiftWidgetsX11
//
//  Created by Michael Long on 7/11/19.
//  Copyright © 2019 Michael Long. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public struct ImageWidget: WidgetViewModifying
    , CustomDebugStringConvertible {

    public var debugDescription: String { "ImageWidget()" }

    public var imageModifier: AnyWidgetModifier?
    public var modifiers: WidgetModifiers?

    public init(_ image: UIImage) {
        self.imageModifier = WidgetModifier(keyPath: \UIImageView.image, value: image)
    }

    public init(named name: String) {
        self.imageModifier = WidgetModifierBlock<UIImageView> { view, context in
            if let image = UIImage(named: name) {
                view.image = image
            }
        }
    }

    public init<O:ObservableElement>(_ observable: O) where O.Element == UIImage? {
        self.imageModifier = WidgetModifierBlock<UIImageView> { view, context in
            observable.asObservable().bind(to: view.rx.image).disposed(by: context.disposeBag)
        }
    }

    public init<O:ObservableElement>(_ observable: O) where O.Element == String {
        self.imageModifier = WidgetModifierBlock<UIImageView> { view, context in
            observable.asObservable().map { UIImage(named: $0) }.bind(to: view.rx.image).disposed(by: context.disposeBag)
        }
    }

    public func build(with context: WidgetContext) -> UIView {
        let view = UIImageView()
        let context = context.set(view: view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // fixes transition animation bug with full screen background images

        imageModifier?.apply(to: view, with: context)

        modifiers?.apply(to: view, with: context)
        
        return view
    }

    public func placeholder(_ image: UIImage) -> Self {
        return modified(WidgetModifier(keyPath: \UIImageView.image, value: image))
    }

    public func with(_ block: @escaping WidgetModifierBlockType<UIImageView>) -> Self {
        return modified(WidgetModifierBlock(block))
    }

}
