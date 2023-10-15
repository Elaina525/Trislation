//
//  Profile.swift
//  TranslateApp
//
//  Created by Naruse on 14/10/2023.
//

import JWTDecode

/// Represents user profile information.
struct Profile {
    /// User's unique identifier.
    let id: String

    /// User's name.
    let name: String

    /// User's email address.
    let email: String

    /// Indicates if the email is verified (true or false).
    let emailVerified: String

    /// URL to the user's profile picture.
    let picture: String

    /// Timestamp indicating when the user profile was last updated.
    let updatedAt: String
}

extension Profile {
    /// An empty profile with default values.
    static var empty: Self {
        return Profile(
            id: "",
            name: "",
            email: "",
            emailVerified: "",
            picture: "",
            updatedAt: ""
        )
    }

    /// Parse user profile information from an ID token.
    ///
    /// - Parameter idToken: A JWT ID token containing user profile claims.
    /// - Returns: A `Profile` instance containing the parsed user profile information.
    static func from(_ idToken: String) -> Self {
        guard
            let jwt = try? decode(jwt: idToken),
            let id = jwt.subject,
            let name = jwt.claim(name: "name").string,
            let email = jwt.claim(name: "email").string,
            let emailVerified = jwt.claim(name: "email_verified").boolean,
            let picture = jwt.claim(name: "picture").string,
            let updatedAt = jwt.claim(name: "updated_at").string
        else {
            return .empty
        }

        return Profile(
            id: id,
            name: name,
            email: email,
            emailVerified: String(describing: emailVerified),
            picture: picture,
            updatedAt: updatedAt
        )
    }
}
