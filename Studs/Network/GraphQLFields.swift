//
//  GraphQLFields.swift
//  Studs
//
//  Created by Glenn Olsson on 2020-12-13.
//  Copyright © 2020 Studieresan. All rights reserved.
//

import Foundation

// TODO: Add role fetching from user

let userFields = """
id
firstName
lastName
studsYear
info {
 role
 email
 phone
 linkedIn
 github
 master
 allergies
 picture
 permissions
 cv {
  sections {
   title
   items {
    title
    description
    when
    organization
    city
   }
  }
 }
}
"""

let companyFields = """
id
name
companyContacts {
 id
 name
 email
 phone
 comment
}
statuses {
 studsYear
 responsibleUser {
  \(userFields)
 }
 statusDescription
 statusPriority
 amount
 salesComments {
  id
  text
  createdAt
  user {
   \(userFields)
  }
 }
}
"""

let eventFields = """
id
date
location
publicDescription
privateDescription
beforeSurvey
afterSurvey
pictures
published
responsible {
 \(userFields)
}
company {
 \(companyFields)
}
studsYear
"""

let happeningFields = """
id
host {
  \(userFields)
}
participants {
  \(userFields)
}
location {
  type
  geometry {
    type
    coordinates
  }
  properties {
    name
  }
}
created
title
emoji
description
"""

func createUsersQuery(role: String?, year: Int?) -> String {
	return """
users(userRole: \(role ?? "null"), studsYear: \(year?.description ?? "null")) {
 \(userFields)
}
"""
}

func createUserQuery() -> String {
	return """
user {
 \(userFields)
}
"""
}

func createCompaniesQuery() -> String {
	return """
companies {
 \(companyFields)
}
"""
}

func createCompanyQuery(id: String) -> String {
	return """
company(companyId: \(id)) {
 \(companyFields)
}
"""
}

func createEventsQuery(year: Int?) -> String {
	return """
events(studsYear: \(year?.description ?? "null")) {
 \(eventFields)
}
"""
}

func createEventQuery(id: String) -> String {
	return """
event(eventId: \(id)) {
 \(eventFields)
}
"""
}

func createHappeningsQuery() -> String {
	return """
happenings {
  \(happeningFields)
}
"""
}
