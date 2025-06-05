//
//  GithubUserRealm.swift
//  TymeXAssignmentUIKit
//
//  Created by thanh tien on 4/6/25.
//

import RealmSwift
import Foundation

final class GithubUserRealm: Object {
   @Persisted var login: String?
   @Persisted var id: Int
   @Persisted var nodeId: String?
   @Persisted var avatarUrl: String?
   @Persisted var gravatarId: String?
   @Persisted var url: String?
   @Persisted var htmlUrl: String?
   @Persisted var followersUrl: String?
   @Persisted var followingUrl: String?
   @Persisted var gistsUrl: String?
   @Persisted var starredUrl: String?
   @Persisted var subscriptionsUrl: String?
   @Persisted var organizationsUrl: String?
   @Persisted var reposUrl: String?
   @Persisted var eventsUrl: String?
   @Persisted var receivedEventsUrl: String?
   @Persisted var type: String?
   @Persisted var userViewType: String?
   @Persisted var siteAdmin: Bool?
    
    init(login: String?, id: Int, nodeId: String? = nil, avatarUrl: String? = nil, gravatarId: String? = nil, url: String? = nil, htmlUrl: String? = nil, followersUrl: String? = nil, followingUrl: String? = nil, gistsUrl: String? = nil, starredUrl: String? = nil, subscriptionsUrl: String? = nil, organizationsUrl: String? = nil, reposUrl: String? = nil, eventsUrl: String? = nil, receivedEventsUrl: String? = nil, type: String? = nil, userViewType: String? = nil, siteAdmin: Bool? = nil) {
        self.login = login
        self.id = id
        self.nodeId = nodeId
        self.avatarUrl = avatarUrl
        self.gravatarId = gravatarId
        self.url = url
        self.htmlUrl = htmlUrl
        self.followersUrl = followersUrl
        self.followingUrl = followingUrl
        self.gistsUrl = gistsUrl
        self.starredUrl = starredUrl
        self.subscriptionsUrl = subscriptionsUrl
        self.organizationsUrl = organizationsUrl
        self.reposUrl = reposUrl
        self.eventsUrl = eventsUrl
        self.receivedEventsUrl = receivedEventsUrl
        self.type = type
        self.userViewType = userViewType
        self.siteAdmin = siteAdmin
    }
}

extension GithubUserRealm: DomainConvertible {
    func toDomain() -> GitHubUser {
        return GitHubUser(
            login: login, id: id, nodeId: nodeId,
            avatarUrl: avatarUrl,
            gravatarId: gravatarId,
            url: url,
            htmlUrl: htmlUrl,
            followersUrl: followersUrl,
            followingUrl: followingUrl,
            gistsUrl: gistsUrl,
            starredUrl: starredUrl,
            subscriptionsUrl: subscriptionsUrl,
            organizationsUrl: organizationsUrl,
            reposUrl: reposUrl,
            eventsUrl: eventsUrl,
            receivedEventsUrl: receivedEventsUrl,
            type: type,
            userViewType: userViewType,
            siteAdmin: siteAdmin
        )
    }
}

