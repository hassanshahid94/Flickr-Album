////
////  ViewController.swift
////  Flickr Album
////
////  Created by Hassan on 28.4.2021.
////
//
//import Foundation
//import UIKit
//import ObjectMapper
//import SnapKit
//
//class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//
//    @IBOutlet weak var txtSeachBar: UISearchBar!
//    @IBOutlet weak var tableView: UITableView!
//
//    var numberOfSection: Int!
//    var keywordsDict: NSDictionary!
//    var keywordsDictLevel2: NSDictionary!
//    var keywordsArrLevel3 = [String]()
//    var filteredDict: NSDictionary!
//
//    var keywordsArr = [String]()
//    var filteredArr = [String]()
//
//    var isSearch = false
//
//    var pets = [String]()
//
//    var collectionVwFilter: UICollectionView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        txtSeachBar.delegate = self
//        keywordsDict = readData(fileName: "flickr-keyword-struct")
//        numberOfSection = keywordsDict?.count
//
//        for (_, element) in keywordsDict.allKeys.enumerated() {
//            keywordsArr.append("\(element)")
//        }
//
//        // let ani = keywordsDict["Animals"]! as? NSDictionary
//        let animalTypes = keywordsDict.value(forKey: "Animals") as? NSDictionary
//        pets = animalTypes?.value(forKey: "Wild animals") as! [String]
//        tableView.dataSource = self
//        tableView.delegate = self
//
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//
//        collectionVwFilter = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50), collectionViewLayout: layout)
//        collectionVwFilter.backgroundColor = UIColor.white
//
//        collectionVwFilter.register(FiltersCCell.self, forCellWithReuseIdentifier: "FiltersCCell")
//        collectionVwFilter.dataSource = self
//        collectionVwFilter.delegate = self
//
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isSearch {
//            return numberOfSection == nil ? 0 : numberOfSection
//        }
//        else {
//            return numberOfSection == nil ? 0 : numberOfSection
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell")! as UITableViewCell
//
//        if isSearch && filteredArr.count != 0 {
//            cell.textLabel?.text = filteredArr[indexPath.row]
//        }
//        else {
//            cell.textLabel?.text = keywordsArr[indexPath.row]
//        }
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 0.3) { [self] in
//            tableView.tableHeaderView = collectionVwFilter
//            collectionVwFilter.snp.makeConstraints { (make) -> Void in
//                make.width.equalToSuperview()
//                make.height.equalTo(50)
//                make.centerXWithinMargins.equalToSuperview()
//            }
//            if isSearch {
//                txtSeachBar.text = "\(filteredArr[indexPath.row])"
////                let keywordsTypes2 = filteredArr.value(forKey: "\(keywordsArr[indexPath.row])") as? NSDictionary
////                print(keywordsTypes2)
//            }
//            else {
//                txtSeachBar.text = "\(keywordsArr[indexPath.row])"
//                keywordsDictLevel2 = keywordsDict.value(forKey: "\(keywordsArr[indexPath.row])") as? NSDictionary
//                print(keywordsDictLevel2!.allKeys)
//
//            }
//            tableView.reloadData()
//            view.endEditing(true)
//        }
//
//    }
////    func updateSearchResults(for searchController: UISearchController) {
////        if let searchText = searchController.searchBar.text {
////            if searchText == "" {
////                isSearch = false
////                numberOfSection = keywordsArr.count
////            }
////            else {
////                isSearch = true
////                filteredArr = keywordsArr.filter { ($0).contains(searchText) }
////                numberOfSection = filteredArr.count
////            }
////        }
////        tableView.reloadData()
////    }
//
//    //Reading Json File response
//    func readData(fileName: String) -> NSDictionary? {
//        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//                if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
//                    return jsonResult as NSDictionary
//                }
//            }
//            catch {
//                print ("File cannot be read...")
//            }
//        }
//        return nil
//    }
//
//}
//
//extension String {
//    func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
//        var ranges: [Range<Index>] = []
//        while let range = range(of: substring, options: options, range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex, locale: locale) {
//            ranges.append(range)
//        }
//        return ranges
//    }
//}
//extension ViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return keywordsDictLevel2.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FiltersCCell", for: indexPath) as! FiltersCCell
//
//        let title = keywordsDictLevel2.allKeys[indexPath.row] as? String
//        cell.btnFilter.setTitle(title, for: .normal)
//        cell.btnFilter.sizeToFit()
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        UIView.animate(withDuration: 0.3) { [self] in
//
//            if isSearch {
////                let keywordsTypes2 = filteredArr.value(forKey: "\(keywordsArr[indexPath.row])") as? NSDictionary
////                print(keywordsTypes2)
//            }
//            else {
//                keywordsArrLevel3 = keywordsDictLevel2.value(forKey: "\(keywordsDictLevel2.allKeys[indexPath.row])") as! [String]
//
//                print(keywordsArrLevel3)
//            }
//            collectionVwFilter.reloadData()
//        }
//    }
//}
//
////MARK:- UICollectionView Delegate and Flowlayout
//extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let width = collectionView.frame.size.width/3.5
//        let height = CGFloat(50.0)
//        return CGSize(width: width, height: height)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
//    {
//        return 5
//
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
//    {
//        return 5
//    }
//}
//
////MARK:- UISearchBar Delegate
//extension ViewController: UISearchBarDelegate {
//    /* this function is triggered whenever there is a change in searchbar text
//         i.e. adding/removing alphabets */
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if let searchText = searchBar.text {
//
//            if searchText == "" {
//                isSearch = false
//                numberOfSection = keywordsArr.count
//                tableView.tableHeaderView = nil
//                searchBar.perform(#selector(self.resignFirstResponder), with: nil, afterDelay: 0.1)
//            }
//            else {
//                isSearch = true
//                filteredArr = keywordsArr.filter { ($0).contains(searchText) }
//                numberOfSection = filteredArr.count
//            }
//        }
//        tableView.reloadData()
//    }
//    // this function is called when search button is tapped!
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//    }
//}
