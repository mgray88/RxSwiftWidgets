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

    public var modifiers: WidgetModifiers?

    public var image: UIImage?

    public init(_ image: UIImage) {
        self.image = image
    }

    public init(named name: String? = nil) {
        if let name = name {
            self.image = UIImage(named: name)
        }
    }

    public func build(with context: WidgetContext) -> UIView {
        let view = UIImageView()
        let context = context.set(view: view)
        
        view.translatesAutoresizingMaskIntoConstraints = false

        if let image = image {
            view.image = image
        }

        modifiers?.apply(to: view, with: context)
        
        return view
    }

    public func image<O:ObservableElement>(_ observable: O) -> Self where O.Element == UIImage? {
        return modified(WidgetModifierBlock<UIImageView> { view, context in
            observable.asObservable().bind(to: view.rx.image).disposed(by: context.disposeBag)
        })
    }

    public func image<O:ObservableElement>(_ observable: O) -> Self where O.Element == String {
        return modified(WidgetModifierBlock<UIImageView> { view, context in
            observable.asObservable().map { UIImage(named: $0) }.bind(to: view.rx.image).disposed(by: context.disposeBag)
        })
    }

    public func with(_ block: @escaping WidgetModifierBlockType<UIImageView>) -> Self {
        return modified(WidgetModifierBlock(block))
    }

}
