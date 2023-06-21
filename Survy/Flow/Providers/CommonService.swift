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
    var allGenres: [Genre] { get set }
    var allSurveys: [Survey] { get set }
    var surveysToShow: [Survey] { get }
    var selectedGenres: Set<Genre> { get set }
    
    func setSelectedIndex(_ index: Int)
    func setGenres(_ genres: [Genre])
    func toggleGenre(_ genre: Genre)
    func getSurveys(completion: @escaping () -> Void)
    func getGenres(completion: @escaping () -> Void)
    func addGenresToSurveys(completion: @escaping ([Survey]?) -> Void)
}

class CommonService: CommonServiceType {
    var selectedGenres = Set<Genre>()
    
//    func toggleGenre(_ genreId: Int) {
    func toggleGenre(_ genre: Genre) {
        selectedGenres.toggle(genre)
    }
    
    var surveysToShow: [Survey] {
        
        print("selectedGenres: \(selectedGenres)")
        print("myGenres: \(UserDefaults.standard.myGenres)")
        
        if selectedGenres.isEmpty {
            var ret = [Survey]()
            for survey in allSurveys {
                if let surveyGenres = survey.genres {
                    let defaultGenres = Set(UserDefaults.standard.myGenres)
                    if defaultGenres.intersection(surveyGenres).isEmpty == false {
                        ret.append(survey)
                    }
                }
            }
            return ret
        } else {
            return allSurveys.filter {
                guard let validGenres = $0.genres else { fatalError() }
                let genreSet = Set(validGenres)
                print("validGenres: \(validGenres) ")
                return genreSet.intersection(selectedGenres).isEmpty == false
            }
        }
    }
    
    
    var allSurveys: [Survey] = []
    var allGenres: [Genre] = []
    
    var selectedIndex: Int = 0
    
    func setSelectedIndex(_ index: Int) {
        selectedIndex = index
    }
    
    func setGenres(_ genres: [Genre]) {
        allGenres = genres
    }
    
    func getSurveys(completion: @escaping () -> Void) {
        APIService.shared.getAllSurveys { surveys in
            guard let surveys = surveys else { return }
            self.allSurveys = surveys
            completion()
        }
    }
    
    func getGenres(completion: @escaping () -> Void) {
        APIService.shared.getAllGenres { genres in
            guard let genres = genres else { return }
            self.allGenres = genres
            completion()
        }
    }
    
    func addGenresToSurveys(completion: @escaping ([Survey]?) -> Void) {
        APIService.shared.getAllSurveyGenres { [weak self] surveyGenres in
            guard let surveyGenres = surveyGenres, let self = self  else { return }
            guard self.allGenres.isEmpty == false, self.allSurveys.isEmpty == false else {
                completion(nil)
                return
            }
            
            var myDic = [SurveyId: [GenreId]]()
            
            for (_, surveyGenre) in surveyGenres.enumerated() {
                let surveyId = surveyGenre.surveyId
                let genreId = surveyGenre.genreId
                if myDic[surveyId] != nil {
                    myDic[surveyId]!.append(genreId)
                } else {
                    myDic[surveyId] = [genreId]
                }
            }
            
            var newSurveys = [Survey]()
            for (surveyId, genreIds) in myDic {
                print("surveyId: \(surveyId), genreIds: \(genreIds)")
                
                guard var correspondingSurvey = self.allSurveys.first(where: { $0.id == surveyId }) else { return }
                
                let genreSet = Set(self.allGenres)
                let genreIdsSet = Set(genreIds)
                let correspondingGenres = genreSet.filter { genre in
                    genreIdsSet.contains(genre.id)
                }
                
                let genreArr = Array(correspondingGenres)
                correspondingSurvey.setGenres(genres: genreArr)
                newSurveys.append(correspondingSurvey)
            }
            
            self.allSurveys = newSurveys
            
            print("newSurveys: \(self.allSurveys)")
            completion(self.allSurveys)
        }
    }
}
