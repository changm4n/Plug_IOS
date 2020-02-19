//
//  HomeExtension.swift
//  Plug
//
//  Created by changmin lee on 13/07/2019.
//  Copyright © 2019 changmin. All rights reserved.
//

import Foundation
import UIKit

extension HomeVC {
    func getTneedToJoin(tName: String, cName: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: "\(tName) 선생님, \n\(cName) 클래스 학부모님들의\n가입을 기다리고있습니다.", attributes: [
            .font: UIFont.systemFont(ofSize: 22.0, weight: .regular),
            .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
            .kern: 0.0
            ])
    }
    
    func getTneedToCreate(tName: String) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: "\(tName) 선생님, \n클래스를 생성해주세요.", attributes: [
            .font: UIFont.systemFont(ofSize: 22.0, weight: .regular),
            .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
            .kern: 0.0
            ])
    }
    
    func getTMessageCount(tName: String, count: Int) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(tName) 선생님, \n", attributes: [
            .font: UIFont.systemFont(ofSize: 22.0, weight: .regular),
            .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
            .kern: 0.0
            ])
        
        let attributedString1 = NSMutableAttributedString(string: "\(count)명", attributes: [
            .font: UIFont.systemFont(ofSize: 22.0, weight: .bold),
            .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
            .kern: 0.0
            ])
        
        let attributedString2 = NSMutableAttributedString(string: "이 메시지를 보냈습니다.", attributes: [
            .font: UIFont.systemFont(ofSize: 22.0, weight: .regular),
            .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
            .kern: 0.0
            ])
        
        attributedString.append(attributedString1)
        attributedString.append(attributedString2)
        
        return attributedString
    }
    
    func getPMessageCount(pName: String, count: Int) -> NSMutableAttributedString {
        let attributedString1 = NSMutableAttributedString(string: "\(pName) 학부모님,\n", attributes: [
            .font: UIFont.systemFont(ofSize: 22.0, weight: .regular),
            .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
            .kern: 0.0
            ])
        let attributedString2 = NSMutableAttributedString(string: "\(count)개", attributes: [
            .font: UIFont.systemFont(ofSize: 22.0, weight: .bold),
            .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
            .kern: 0.0
            ])
        let attributedString3 = NSMutableAttributedString(string: "의 메시지를 받았습니다.", attributes: [
            .font: UIFont.systemFont(ofSize: 22.0, weight: .regular),
            .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
            .kern: 0.0
            ])
        let attr = NSMutableAttributedString()
        attr.append(attributedString1)
        attr.append(attributedString2)
        attr.append(attributedString3)
        
        return attr
    }
}
