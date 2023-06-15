//
//  CommonService.swift
//  Survy
//
//  Created by Mac mini on 2023/06/13.
//
import API
import Foundation
import Model

protocol CommonServiceType {
    var selectedIndex: Int { get set }
    var allTags: [Tag] { get set }
    var allSurveys: [Survey] { get set }
    var surveysToShow: [Survey] { get }
    var selectedCategories: Set<Tag> { get set }
    
    func setSelectedIndex(_ index: Int)
    func setTags(_ tags: [Tag])
    func toggleCategory(_ category: Tag)
    func getSurveys(completion: @escaping () -> Void)
    func getTags(completion: @escaping () -> Void)
    func addTagsToSurveys(completion: @escaping ([Survey]?) -> Void)
}

class CommonService: CommonServiceType {
    var selectedCategories = Set<Tag>()
    
//    func toggleCategory(_ categoryId: Int) {
    func toggleCategory(_ category: Tag) {
        selectedCategories.toggle(category)
    }
    
    var surveysToShow: [Survey] {
        
        print("selectedCategories: \(selectedCategories)")
        print("myCategories: \(UserDefaults.standard.myCategories)")
        
        if selectedCategories.isEmpty {
            var ret = [Survey]()
            for survey in allSurveys {
                if let surveyCategories = survey.tags {
                    let defaultCategories = Set(UserDefaults.standard.myCategories)
                    if defaultCategories.intersection(surveyCategories).isEmpty == false {
                        ret.append(survey)
                    }
                }
            }
            return ret
        } else {
            return allSurveys.filter {
                guard let validCategories = $0.tags else { fatalError() }
                let categorySet = Set(validCategories)
                print("validCategories: \(validCategories) ")
                return categorySet.intersection(selectedCategories).isEmpty == false
            }
        }
    }
    
    
    var allSurveys: [Survey] = []
    var allTags: [Tag] = []
    
    var selectedIndex: Int = 0
    
    func setSelectedIndex(_ index: Int) {
        selectedIndex = index
    }
    
    func setTags(_ tags: [Tag]) {
        allTags = tags
    }
    
    func getSurveys(completion: @escaping () -> Void) {
        APIService.shared.getAllSurveys { surveys in
            guard let surveys = surveys else { return }
            self.allSurveys = surveys
            completion()
        }
    }
    
    func getTags(completion: @escaping () -> Void) {
        APIService.shared.getAllTags { tags in
            guard let tags = tags else { return }
            self.allTags = tags
            completion()
        }
    }
    
    func addTagsToSurveys(completion: @escaping ([Survey]?) -> Void) {
        APIService.shared.getAllSurveyTags { [weak self] surveyTags in
            guard let surveyTags = surveyTags, let self = self  else { return }
            guard self.allTags.isEmpty == false, self.allSurveys.isEmpty == false else {
                completion(nil)
                return
            }
            
            var myDic = [SurveyId: [TagId]]()
            
            for (_, surveyTag) in surveyTags.enumerated() {
                let surveyId = surveyTag.surveyId
                let tagId = surveyTag.tagId
                if myDic[surveyId] != nil {
                    myDic[surveyId]!.append(tagId)
                } else {
                    myDic[surveyId] = [tagId]
                }
            }
            
            var newSurveys = [Survey]()
            for (surveyId, tagIds) in myDic {
                print("surveyId: \(surveyId), tagIds: \(tagIds)")
                
                guard var correspondingSurvey = self.allSurveys.first(where: { $0.id == surveyId }) else { return }
                
                let tagSet = Set(self.allTags)
                let tagIdsSet = Set(tagIds)
                let correspondingTags = tagSet.filter { tag in
                    tagIdsSet.contains(tag.id)
                }
                
                let tagArr = Array(correspondingTags)
                correspondingSurvey.setCategories(tags: tagArr)
                newSurveys.append(correspondingSurvey)
            }
            
            self.allSurveys = newSurveys
            
            print("newSurveys: \(self.allSurveys)")
            completion(self.allSurveys)
        }
    }
}
