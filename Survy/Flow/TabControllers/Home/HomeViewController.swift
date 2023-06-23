//
//  HomeViewController.swift
//  Survy
//
//  Created by Mac mini on 2023/03/31.
//

import UIKit
import SnapKit
import Model

class HomeViewController: TabController, Coordinating {

    override func updateMyUI() {
        updateSurveys()
        genreCollectionView.reloadData()
    }
    
    enum Section {
        case main
    }
    
    var participationService: ParticipationServiceType
    var userService: UserServiceType
    var commonService: CommonServiceType
    var coordinator: Coordinator?
    var surveyCellHeights = Set<CellHeight>()
    var tableViewTotalHeight: CGFloat {
        return surveyCellHeights.map { $0.height }.reduce(0, +)
    }
    var hasGenrePinnedToTheTop = false
    var surveyDataSource: UITableViewDiffableDataSource<Section, Survey>! = nil
    
    var topViewHeightConstraint: NSLayoutConstraint?

    private var isAnimationInProgress = false
    private let genreHeight: CGFloat = 50
    
    init(index: Int,
         participationService: ParticipationServiceType,
         userService: UserServiceType,
         commonService: CommonServiceType) {
        self.participationService = participationService
        self.userService = userService
        self.commonService = commonService
        super.init(index: index)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.mainBackgroundColor
        self.registerTableView()
        
        self.configureDataSource()

        self.setupDelegates()
        self.setupTargets()
        self.setupGenreCollectionView()
        self.setupLayout()
        
        coordinator?.setIndicatorSpinning(true)
        // Get all genres, match them to surveys and update UI
        
        commonService.getSurveys { [weak self] in
            self?.commonService.getGenres(completion: { [weak self] in
                self?.commonService.addGenresToSurveys(completion: { [weak self] surveys in
                    self?.coordinator?.setIndicatorSpinning(false)
                    self?.updateSurveys()
                })
                self?.genreSelectionButton.isUserInteractionEnabled = true
            })
        }
    }
    
    private func setupDelegates() {
        wholeScrollView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard navigationController != nil else { fatalError() }
        coordinator?.testSetup()
        setupLayout()
    }
    
    private func configureDataSource() {
        self.surveyDataSource = UITableViewDiffableDataSource<Section, Survey>(tableView: surveyTableView, cellProvider: { [weak self] tableView, indexPath, itemIdentifier -> UITableViewCell? in
            guard let self = self else { return nil }
            let cell = tableView.dequeueReusableCell(withIdentifier: SurveyTableViewCell.reuseIdentifier, for: indexPath) as! SurveyTableViewCell
            cell.survey = commonService.surveysToShow[indexPath.row]
            cell.surveyDelegate = self
            return cell
        })
    }
    
    private func registerTableView() {
        surveyTableView.register(SurveyTableViewCell.self, forCellReuseIdentifier: SurveyTableViewCell.reuseIdentifier)
        surveyTableView.delegate = self

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.screenWidth, height: 50))
        surveyTableView.tableFooterView = footerView
    }
    
    private func setupGenreCollectionView(){
        genreCollectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.reuseIdentifier)
        genreCollectionView.dataSource = self
        genreCollectionView.delegate = self
    }
    
    private func updateSurveys() {
        surveyCellHeights.removeAll()
        var snapshot = NSDiffableDataSourceSnapshot<Section, Survey>()
        snapshot.appendSections([.main])
        snapshot.appendItems(commonService.surveysToShow)
        self.surveyDataSource.apply(snapshot)
        DispatchQueue.main.async {
            self.surveyTableView.reloadData()
        }
        
        print("fetchedSurveys: \(commonService.surveysToShow)")
        
        if commonService.surveysToShow.isEmpty {
            
            if UserDefaults.standard.myGenres.isEmpty {
                noDataLabel.text = "Select Genre first"
            } else {
                noDataLabel.text = "There's no survey available with current genres"
            }
        }
        self.setTableVisibility(shouldShowTable: !commonService.surveysToShow.isEmpty)
    }
    
    private func setTableVisibility(shouldShowTable: Bool) {
        self.surveyTableView.isHidden = !shouldShowTable
        self.noDataLabel.isHidden = shouldShowTable
    }
    
    private func setupTargets() {
        requestingButton.addTarget(self, action: #selector(moveToPostSurvey), for: .touchUpInside)
        genreSelectionButton.addTarget(self, action: #selector(genreSelectionButtonTapped), for: .touchUpInside)
    }
    
    @objc func genreSelectionButtonTapped() {
        coordinator?.manipulate(.genreSelection(.participating), command: .present)
    }
    
    @objc func moveToPostSurvey() {
        coordinator?.move(to: .postingController)
    }
    
    private func setupLayout() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(wholeScrollView)
        self.view.addSubview(requestingButton)
        self.view.addSubview(safeAreaCoveringView)
        
        safeAreaCoveringView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(40)
        }
        
        [
         genreSelectionCoveringView, collectedRewardLabel, surveyTableView, noDataLabel,
         genreSelectionButton, genreCollectionView].forEach {
             self.wholeScrollView.addSubview($0)
         }
        
        wholeScrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-tabbarHeight - 50)
        }
        
        collectedRewardLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(UIScreen.screenWidth - 12 - 100)
            make.height.equalTo(28)
            make.top.equalToSuperview()
        }
        
        genreSelectionCoveringView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(UIScreen.screenWidth)
            make.top.equalTo(collectedRewardLabel.snp.bottom).offset(20)
            make.height.equalTo(genreHeight)
        }
        
        genreSelectionButton.snp.makeConstraints { make in
            make.top.equalTo(collectedRewardLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(12)
            make.width.equalTo(UIScreen.screenWidth / 6)
            make.height.equalTo(genreHeight)
        }
        
        genreCollectionView.snp.makeConstraints { make in
            make.top.equalTo(collectedRewardLabel.snp.bottom).offset(20)
            make.leading.equalTo(genreSelectionButton.snp.trailing).offset(8)
            make.width.equalTo(UIScreen.screenWidth * 5 / 6 - 32)
            make.height.equalTo(genreSelectionButton.snp.height)
        }
        
        requestingButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-tabbarHeight)
            make.height.equalTo(50)
            make.leading.equalToSuperview()
            make.width.equalTo(UIScreen.screenWidth)
        }
        
        surveyTableView.snp.makeConstraints { make in
            make.top.equalTo(collectedRewardLabel.snp.bottom).offset(genreHeight + 20)
            make.leading.equalToSuperview()
            make.width.equalTo(UIScreen.screenWidth)
            make.bottom.equalTo(requestingButton.snp.top)
        }
        
        noDataLabel.snp.makeConstraints { make in
            make.top.equalTo(collectedRewardLabel.snp.bottom).offset(genreHeight + 20)
            make.leading.equalToSuperview()
            make.width.equalTo(UIScreen.screenWidth)
            make.bottom.equalTo(requestingButton.snp.top)
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let text = numberFormatter.string(from: userService.collectedMoney as NSNumber) else { return }

        collectedRewardLabel.addFrontImage(
            image: UIImage.coin, string: text + "P",
            font: UIFont.systemFont(ofSize: collectedRewardLabel.font.pointSize, weight: .bold),
            color: UIColor.blueTextColor)
    }
    
    // MARK: - Views
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        wholeScrollView.contentSize = CGSize(width: UIScreen.screenWidth, height: tableViewTotalHeight + 150)
        print("tableViewTotalHeight applied: \(tableViewTotalHeight)")
        print("viewDidAppear Called")
    }
    
    private let wholeScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let noDataLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private let requestingButton: UIButton = {
        let button = UIButton()
        let attributedTitle = NSAttributedString(string: "설문 요청", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .semibold), .foregroundColor: UIColor.white, .paragraphStyle: NSMutableParagraphStyle.centerAlignment])
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.backgroundColor = UIColor.deeperMainColor
        return button
    }()
    
    private let upperContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let collectedRewardLabel: PaddedLabel = {
        let label = PaddedLabel()
        label.textAlignment = .right
        label.layer.cornerRadius = 14
        label.clipsToBounds = true
        label.backgroundColor = UIColor.mainColor
        return label
    }()
    
    private let genreSelectionButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .mainBackgroundColor
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private lazy var genreCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: UIScreen.screenWidth / 6, height: genreHeight)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .mainBackgroundColor
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    private let surveyTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        return tableView
    }()
    
    private let safeAreaCoveringView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBackgroundColor
        view.isHidden = true
        return view
    }()
    
    private let genreSelectionCoveringView: UIView = {
        let view = UIView()
        view.backgroundColor = .mainBackgroundColor
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let approximatedWidthOfBioTextView = UIScreen.screenWidth - 16 * 2 - 12 * 2
        let size = CGSize(width: approximatedWidthOfBioTextView, height: 1000)
        let estimatedFrame1 = NSString(string: " ").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 12)], context: nil)

        let estimatedFrame2 = NSString(string: " ").boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 13)], context: nil)
        
        let estimatedFrame3 = NSString(string: commonService.surveysToShow[indexPath.row].title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 18)], context: nil)
        
        // 12 + 10 + 12 + 20 + 12
        let spacings: CGFloat = 66
        let sizes: CGFloat = 30
        let frameHeight = [estimatedFrame1, estimatedFrame2, estimatedFrame3].map { $0.height }.reduce(0, +)
        let heightSum = frameHeight + spacings + sizes

        let cellHeight = CellHeight(index: indexPath.row, height: heightSum)
        surveyCellHeights.insert(cellHeight)
        print("tableViewTotalHeight: \(tableViewTotalHeight), indexPath: \(indexPath.row), addedAmount: \(heightSum)")
        viewDidAppear(false)
        return heightSum
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        surveyCellHeights.removeAll()
        return UserDefaults.standard.myGenres.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let collectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.reuseIdentifier, for: indexPath) as! GenreCollectionViewCell
        
        collectionViewCell.genreCellDelegate = self
        let genre = UserDefaults.standard.myGenres[indexPath.row]
        
        collectionViewCell.genre = genre
        return collectionViewCell
    }
}

extension HomeViewController: GenreCellDelegate {
    func genreTapped(genre: Genre, selected: Bool) {
        commonService.toggleGenre(genre)
        updateSurveys()
    }
}

extension HomeViewController: SurveyTableViewDelegate {
    func surveyTapped(_ cell: SurveyTableViewCell) {
        guard let selectedSurvey = cell.survey else { fatalError() }
        participationService.currentSurvey = selectedSurvey
        coordinator?.move(to: .questionController)
    }
}

extension HomeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let edgeHeight: CGFloat = 24.0
        if scrollView.contentOffset.y > edgeHeight && hasGenrePinnedToTheTop == false {
            safeAreaCoveringView.isHidden = false
            hasGenrePinnedToTheTop = true
            
            // TODO: pin to the top
            [genreSelectionCoveringView, genreSelectionButton, genreCollectionView ].forEach {
                $0.removeFromSuperview()
                self.view.addSubview($0)
            }
            
            self.view.addSubview(safeAreaCoveringView)
            
            genreSelectionCoveringView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(40)
                make.leading.equalToSuperview()
                make.width.equalTo(UIScreen.screenWidth)
                make.height.equalTo(genreHeight)
            }
            
            genreSelectionButton.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(40)
                make.leading.equalToSuperview().offset(12)
                make.width.equalTo(UIScreen.screenWidth / 6)
                make.height.equalTo(genreHeight)
            }
            
            genreCollectionView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(40)
                make.leading.equalTo(genreSelectionButton.snp.trailing).offset(8)
                make.width.equalTo(UIScreen.screenWidth * 5 / 6 - 32)
                make.height.equalTo(genreHeight)
            }
            
        } else if scrollView.contentOffset.y <= edgeHeight && hasGenrePinnedToTheTop == true {
            
            safeAreaCoveringView.isHidden = true

            hasGenrePinnedToTheTop = false
            
            [genreSelectionCoveringView, genreSelectionButton, genreCollectionView].forEach {
                $0.removeFromSuperview()
                self.wholeScrollView.addSubview($0)
            }
            
            genreSelectionCoveringView.snp.makeConstraints { make in
                make.top.equalTo(collectedRewardLabel.snp.bottom).offset(20)
                make.leading.equalToSuperview()
                make.width.equalTo(UIScreen.screenWidth)
                make.height.equalTo(genreHeight)
            }
            
            genreSelectionButton.snp.makeConstraints { make in
                make.top.equalTo(collectedRewardLabel.snp.bottom).offset(20)
                make.leading.equalToSuperview().offset(12)
                make.width.equalTo(UIScreen.screenWidth / 6)
                make.height.equalTo(genreHeight)
            }
            
            genreCollectionView.snp.makeConstraints { make in
                make.top.equalTo(collectedRewardLabel.snp.bottom).offset(20)
                make.leading.equalTo(genreSelectionButton.snp.trailing).offset(8)
                make.width.equalTo(UIScreen.screenWidth * 5 / 6 - 32)
                make.height.equalTo(genreSelectionButton.snp.height)
            }
        }
    }
}
