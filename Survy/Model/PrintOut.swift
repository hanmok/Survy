//import Foundation
//
//
//
//
//
//struct Survey {
//    let id: Int
//    let numOfParticipation: Int
//    let participationGoal: Int
//    let ended_at: Date? = nil
//    let title: String
//    let rewardRange: [Int]
//
//    // need to get from Survey-Tag API
//    var categories: [String]
//
//    var participants: [Int] {
//        return [self.numOfParticipation, participationGoal]
//    }
//
//    var rewardString: String? {
//        if rewardRange.count == 1 {
//            return "\(rewardRange.first!)"
//        }
//        if let min = rewardRange.min(),
//           let max = rewardRange.max() {
//            return "\(min) ~ \(max)"
//        } else { return nil }
//    }
//}
//
//enum QuestionType: String {
//    case singleSelection = "단일 선택"
//    case muiltipleSelection = "다중 선택"
//    case shortSentence = "단답형"
//    case essay = "서술형"
//    case multipleSentences = "다중 단답형"
//}
//
//struct Question {
//    let id: Int
//    let questionType: QuestionType
//    let sectionId: Int
//    let position: Int
//    let text: String
//    let expectedTimeInSec: Int
//    let selectableOptions: [SelectableOption]
//    let correctAnswer: Int? // references selectableOption
//}
//
//struct Section {
//    let id: Int = Int.random(in: 0 ... 10000)
//    let surveyId: Int
//    let expectedTimeInSec: Int = 5
//    let reward: Int = 100
//    let title: String = ""
//    let numOfQuestions: Int
//}
//
//struct User {
//    let id: Int
//    let username: String
//    let collectedReward: Int
//    let fatigue: Int
//    let creditAmount: Int
//    let deviceToken: String
//    let age: Int
//    let isMale: Bool
//    let nickname: String
//    let categories: [String] = []
//}
//
//struct SelectableOption {
//    let id: Int = Int.random(in: 0 ... 10000)
//    let questionId: Int
//    let position: Int
//    var value: String? = nil
//    var placeHolder: String? = nil
//}
//
//struct Tag: Decodable {
//    let id: Int
//    let name: String
//}
