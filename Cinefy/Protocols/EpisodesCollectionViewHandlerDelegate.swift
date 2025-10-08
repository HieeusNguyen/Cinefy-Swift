//
//  EpisodesCollectionViewHandlerDelegate.swift
//  Cinefy
//
//  Created by Nguyễn Hiếu on 8/10/25.
//

import Foundation

protocol EpisodesCollectionViewHandlerDelegate: AnyObject {
    func didSelectEpisode(with url: URL)
}
