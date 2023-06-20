//
//  TestData.swift
//  Model
//
//  Created by Mac mini on 2023/05/03.
//

import Foundation

public let dietQuestion1 = Question(id: 1, questionType: .singleSelection, sectionId: 1, position: 1, text: "다이어트를 위해 약물을 복용해 본 적이 있나요?", expectedTimeInSec: 5, selectableOptions: [
    SelectableOption(position: 1, value: "네", placeHolder: nil),
    SelectableOption( position: 2, value: "아니오", placeHolder: nil)]
)

public let dietQuestion2 = Question(id: 2, questionType: .multipleSelection, sectionId: 1, position: 2, text: "어떤 경로를 통해 해당 약물을 알게되었나요?", expectedTimeInSec: 5, selectableOptions: [
    SelectableOption(position: 1, value: "지인 소개"),
    SelectableOption(position: 2, value: "SNS"),
    SelectableOption(position: 3, value: "기타 광고")
])

public let dietQuestion3 = Question(id: 3, questionType: .shortSentence, sectionId: 1, position: 3, text: "해당 약물을 통한 경험은 어땠나요?", expectedTimeInSec: 5, selectableOptions: [
//    SelectableOption(questionId: 2, position: 1, value: "예"),
//    SelectableOption(questionId: 2, position: 2, value: "아니오")
    SelectableOption(position: 1, value: nil, placeHolder: "경험을 공유해주세요.")
])

// public let section = Section(surveyId: 1, numOfQuestions: 3)
