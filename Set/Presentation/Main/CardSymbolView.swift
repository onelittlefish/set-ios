//
//  CardSymbolView.swift
//  Set
//
//  Copyright (c) 2019 Jihan. All rights reserved.
//

import Foundation
import UIKit

class CardSymbolView: UIView {
    let card: Card

    init(frame: CGRect, card: Card) {
        self.card = card
        super.init(frame: frame)
    }

    // MARK: - NSCoding

    required init?(coder aDecoder: NSCoder) {
        card = Card(coder: aDecoder)
        super.init(coder: aDecoder)
    }

    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        card.encodeWithCoder(aCoder)
    }

    // MARK: - UIView

    // swiftlint:disable:next function_body_length
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let layerWidth: CGFloat = 100
        let layerHeight: CGFloat = 68
        let scale = contentScaleFactor

        guard
            let shapeLayer = CGLayer(context, size: CGSize(width: layerWidth * scale, height: layerHeight * scale), auxiliaryInfo: nil),
            let shapeContext = shapeLayer.context else { return }

        shapeContext.scaleBy(x: scale, y: scale)

        let shapeWidth: CGFloat = 25
        let shapeHeight: CGFloat = 50

        // Shape
        let bezierPath = UIBezierPath.bezierPathForShape(card.shape, withWidth: shapeWidth, height: shapeHeight)
        let path = bezierPath.cgPath
        shapeContext.addPath(path)

        // Color
        let fillColor = card.color.uiColor
        shapeContext.setFillColor(fillColor.cgColor)
        shapeContext.setStrokeColor(fillColor.cgColor)

        // Fill
        switch card.fill {
        case .empty:
            shapeContext.strokePath()
        case .lined:
            shapeContext.saveGState()

            UIGraphicsBeginImageContext(CGSize(width: shapeWidth, height: 12))
            fillColor.setFill()
            UIRectFill(CGRect(x: 0, y: 0, width: shapeWidth, height: 4))
            let pattern = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            shapeContext.restoreGState()

            let fillPattern = UIColor(patternImage: pattern!)

            shapeContext.setFillColor(fillPattern.cgColor)
            shapeContext.fillPath()

            shapeContext.addPath(path)
            shapeContext.strokePath()
        case .solid:
            shapeContext.fillPath()
        }

        context.translateBy(
            x: (bounds.size.width - (shapeWidth + 5.0) * CGFloat(card.number.rawValue)) / 2.0,
            y: (bounds.size.height - shapeHeight) / 2.0
        )

        // Number
        context.saveGState()
        for _ in 0..<card.number.rawValue {
            context.draw(shapeLayer, in: CGRect(x: 0, y: 0, width: layerWidth, height: layerHeight))
            context.translateBy(x: (shapeWidth + 5.0), y: 0.0)
        }
        context.restoreGState()

        // The documentation for CGLayerCreateWithContext indicates that we should call CGLayerRelease
        // but that causes an EXC_BAD_ACCESS
//        CGLayerRelease(shapeLayer)
    }
}

private extension UIBezierPath {
    class func bezierPathForShape(_ shape: Card.Shape, withWidth width: CGFloat, height: CGFloat) -> UIBezierPath {
        let bezierPath: UIBezierPath
        switch shape {
        case .diamond:
            bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint(x: (width / 2) + 1, y: 1))
            bezierPath.addLine(to: CGPoint(x: width + 1, y: (height / 2) + 1))
            bezierPath.addLine(to: CGPoint(x: (width / 2) + 1, y: height + 1))
            bezierPath.addLine(to: CGPoint(x: 1, y: (height / 2) + 1))
            bezierPath.addLine(to: CGPoint(x: (width / 2) + 1, y: 1))
        case .pill:
            bezierPath = UIBezierPath(roundedRect: CGRect(x: 1, y: 1, width: width, height: height),
                cornerRadius: (width / 2))
        case .squiggle:
            bezierPath = UIBezierPath()
            bezierPath.move(to: CGPoint.zero)
            bezierPath.addCurve(to: CGPoint(x: width, y: height),
                controlPoint1: CGPoint(x: (width * 1.5), y: height / 2.0),
                controlPoint2: CGPoint(x: (width * 0.5), y: height / 2.0))
            bezierPath.addCurve(to: CGPoint(x: 0, y: 0),
                controlPoint1: CGPoint(x: -(width * 0.5), y: height / 2.0),
                controlPoint2: CGPoint(x: (width * 0.5), y: height / 2.0))
        }
        return bezierPath
    }
}
