//
//  Queries.swift
//  Plug
//
//  Created by changmin lee on 02/12/2018.
//  Copyright © 2018 changmin. All rights reserved.
//

import Foundation

/*# Write your query or mutation here
 query me {
 me{
 id
 name
 type
 role
 password
 profileImageUrl
 phoneNumber
 userId
 }
 }
 
 #
 
 # mutation  {
 #   createChatRoom(data : {
 #     name: "testname",
 #     userIds: ["koo_mini@naver.com"],
 
 #   }) {
 #     inviteCode
 #     name
 #     admins {
 #       name
 #     }
 #   }
 # }EECEFM
 
 query chatrooms {
 chatRooms(
 where: { admins_some: { userId: "koo_mini@naver.com" } },
 ) {
 id
 name
 admins {
 name
 }
 }
 }
 
 mutation joinChat{
 applyChatRoom(id: "cjp6yml5h6m0a0a6229f2g3eq",data : {
 userId : "lcmini6528@gmail.com",
 kidName : "창민애기"
 }) {
 inviteCode
 }
 }
 
 # mutation SignIn {
 #     signin(userId: "lcmini6528@gmail.com", password: "dlckd456") {
 #         token
 #     }
 # }
 
 query kids {
 kids {
 name
 parents {
 name
 }
 }
 }
 
 query messages {
 messages {
 text
 receivers {
 name
 }
 sender {
 name
 }
 }
 }
 query messageSummaries {
 messageSummaries {
 chatRoom {
 name
 }
 sender {
 name
 id
 }
 receiver {
 name
 id
 }
 id
 }
 }
 
 query notices {
 notices {
 text
 }
 }
 mutation sendMessage {
 sendMessage(data :{
 text : "hello world3",
 chatRoomId : "cjp6yml5h6m0a0a6229f2g3eq",
 fileIds :[],
 receiverIds :["koo_mini@naver.com"]
 }) {
 text
 }
 }
 # 선생 토큰
 # {"Authorization" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJrb29fbWluaUBuYXZlci5jb20iLCJyb2xlIjoiVEVBQ0hFUiIsImV4cGlyZXNJbiI6IjdkIiwiaWF0IjoxNTQzNzU4MDgwfQ.yvPMNeSFgtdHaN9gOjZLJqmjzFt6LjK49dA_giJkNIE"}
 #부모토큰
 # {"Authorization" : "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJsY21pbmk2NTI4QGdtYWlsLmNvbSIsInJvbGUiOiJQQVJFTlQiLCJleHBpcmVzSW4iOiI3ZCIsImlhdCI6MTU0Mzc2MDQwNH0.nZpOhXmA6BBKB-795USiv-eE_St7M85mztRsBcF5H3U"}
 */
