//
//  Strings.swift
//  Plug
//
//  Created by changmin lee on 2018. 10. 21..
//  Copyright © 2018년 changmin. All rights reserved.
//

import Foundation
import UIKit

let kLaunchDescString: NSMutableAttributedString = { () -> NSMutableAttributedString in
    let attributedString = NSMutableAttributedString(string: "이메일과 카카오톡 계정은 타인에게 노출되지 않습니다. 회원가입 시 개인정보 취급방침 및 이용약관에 동의한 것으로 간주합니다. ", attributes: [
        .font: UIFont(name: "AppleSDGothicNeo-Regular", size: 12.0)!,
        .foregroundColor: UIColor.grey,
        .kern: -0.24
        ])
    attributedString.addAttribute(.font, value: UIFont(name: "AppleSDGothicNeo-Bold", size: 12.0)!, range: NSRange(location: 37, length: 16))
    return attributedString
}()

let kLaunchTestDescString: NSMutableAttributedString = { () -> NSMutableAttributedString in
    let attributedString = NSMutableAttributedString(string: "Plug Test Build", attributes: [
        .font: UIFont(name: "AppleSDGothicNeo-Regular", size: 12.0)!,
        .foregroundColor: UIColor.grey,
        .kern: -0.24
        ])
    return attributedString
}()

let kLaunchTitleString: NSMutableAttributedString = { () -> NSMutableAttributedString in
    let attributedString = NSMutableAttributedString(string: "플러그, \n학부모와 교사를 \n새롭게 연결합니다.", attributes: [
        .font: UIFont(name: "AppleSDGothicNeo-Bold", size: 24.0)!,
        .foregroundColor: UIColor.darkGrey,
        .kern: 0.0
        ])
    attributedString.addAttribute(.foregroundColor, value: UIColor.plugBlue, range: NSRange(location: 0, length: 4))
    return attributedString
}()

let kTeacherSettingDesk = "근무 시간을 설정하게 되면, 근무 종료시간 이후에는 선생님께서 메시지를 바로 확인하실 수 없다는 안내를 해드립니다."
