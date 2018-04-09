//
//  ParseTag.swift
//  CampusTour
//
//  Created by Ji Hwan Seung on 4/5/18.
//  Copyright © 2018 cuappdev. All rights reserved.
//

import Foundation

extension EventTag {
    func collegeTagMap(id: String) -> (String, String)? {
        guard let tag = schoolTagMapping[id] else { return nil }
        return tag
    }
    
    func generalTagMap(id: String) -> String? {
        guard let tag = generalTagMapping[id] else { return nil }
        return tag
    }
}

class Tag {
    static let schoolFilters: [(String, String)] = [
        ("General", ""),
        ("A&S","Arts and Sciences"),
        ("AAP","Arts, Architecture, and Planning"),
        ("CALS", "Agriculture and Life Science"),
        ("ENG", "Engineering"),
        ("HE", "Human Ecology"),
        ("ILR", "Industrial and Labor Relations"),
        ("Dyson", "SC Johnson School of Business"),
        ("JCB Hotel", "SC Johnson School of Business"),
    ]
    static let typeFilters: [String] = [
        "Academic Core",
        "Class",
        "General",
        "Office Hour",
        "Social",
        "Tour",
    ]
    static let specialInterestFilters: [String] = [
        "Biological Science",
        "Financial Aid",
        "Pre-Med",
        "Pre-Vet",
        "Study Abroad",
    ]
}

//A lot of hard-coding, but necessary to format names correctly

//Maps tag to (School abbreviation, School full name) tuple
fileprivate let schoolTagMapping: [String: (String, String)] = [
    "4432D6B5-9DAA-484F-1BA06B88A600DD13": Tag.schoolFilters[0],
    "443184C3-0AB0-9353-C820A27EBF82212C": Tag.schoolFilters[1],
    "442F8473-E020-E96D-13B0C037DFF375A2": Tag.schoolFilters[2],
    "44347B7B-9AEA-A36C-7E8B4C4923E4D41C": Tag.schoolFilters[3],
    "443655DC-FDF8-ECD0-7BFDFEE35BBB2FA9": Tag.schoolFilters[4],
    "4437CEE3-B6CE-2AE8-4054AA4C92529A9C": Tag.schoolFilters[5],
    "44418B16-C2DD-39B7-DEA0F7D6DA21C2F1": Tag.schoolFilters[6],
    "444370A4-024F-03AF-E60870B47DDE635A": Tag.schoolFilters[7],
]

//Maps tag to all tag names
let generalTagMapping: [String: String] = [
    "444D3247-A274-FB94-C20AF80D4699C14A": Tag.typeFilters[0],
    "445370B2-EC54-AE8E-51505078028C8455": Tag.typeFilters[1],
    "4457BB5B-BFB1-BDFE-D621894EC1D64A2B": Tag.typeFilters[2],
    "445B4587-CD4D-A9D4-E3E123043889E79B": Tag.typeFilters[3],
    "444FCABA-B6C3-8E8D-E765ACD2A0487944": Tag.typeFilters[4],
    "4451C683-00C9-86AE-6FAAAC051F27BA11": Tag.typeFilters[5],
    "78003A66-D73B-9AB8-ED102FFF2DD530A0": Tag.specialInterestFilters[0],
    "4470401D-F857-0705-9C827BEB8BAF4348": Tag.specialInterestFilters[1],
    "445EDDD6-C90F-397D-AE46AAD918EC1E4C": Tag.specialInterestFilters[2],
    "44602C2E-B537-567A-EEBE5D7130A03637": Tag.specialInterestFilters[3],
    "7802B10A-D09B-184D-9B3C4B69B1B48D66": Tag.specialInterestFilters[4],
    "4432D6B5-9DAA-484F-1BA06B88A600DD13": Tag.schoolFilters[1].0,
    "443184C3-0AB0-9353-C820A27EBF82212C": Tag.schoolFilters[2].0,
    "442F8473-E020-E96D-13B0C037DFF375A2": Tag.schoolFilters[3].0,
    "44347B7B-9AEA-A36C-7E8B4C4923E4D41C": Tag.schoolFilters[4].0,
    "443655DC-FDF8-ECD0-7BFDFEE35BBB2FA9": Tag.schoolFilters[5].0,
    "4437CEE3-B6CE-2AE8-4054AA4C92529A9C": Tag.schoolFilters[6].0,
    "44418B16-C2DD-39B7-DEA0F7D6DA21C2F1": Tag.schoolFilters[7].0,
    "444370A4-024F-03AF-E60870B47DDE635A": Tag.schoolFilters[8].0,
]
