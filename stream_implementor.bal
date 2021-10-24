// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

class TableStream {
    private string[] currentEntries = [];
    private int index = 0;
    private final http:Client httpClient;
    private final string accessKeyId;
    private final string secretAccessKey;
    // private final string? securityToken;
    private final string region;
    private final string awsHost;
    private final string uri = SLASH;
    private final int? 'limit;
    private string? exclusiveStartTableName;


    isolated function init(http:Client httpClient, string host, string accessKey, string secretKey, string region,
                           string? exclusiveStartTableName , int? 'limit) returns error? {
        self.httpClient = httpClient;
        self.accessKeyId = accessKey;
        self.secretAccessKey = secretKey;
        self.region = region;
        self.awsHost = AWS_SERVICE + DOT + self.region + DOT + AWS_HOST;
        self.'limit = 'limit;
        self.exclusiveStartTableName = exclusiveStartTableName;
        self.currentEntries = check self.fetchTableNames();
    }

    public isolated function next() returns record {| string value; |}|error? {
        if (self.index < self.currentEntries.length()) {
            record {| string value; |} tableName = {value: self.currentEntries[self.index]};
            self.index += 1;
            return tableName;
        }
        if (self.exclusiveStartTableName is string) {
            self.index = 0;
            self.currentEntries = check self.fetchTableNames();
            record {| string value; |} tableName = {value: self.currentEntries[self.index]};
            self.index += 1;
            return tableName;
        }
    }

    isolated function fetchTableNames() returns string[]|error {
        string target = VERSION + DOT + "ListTables";
        TableListingRequest request = {
            ExclusiveStartTableName: self.exclusiveStartTableName,
            Limit: self.'limit
        };
        json payload = check request.cloneWithType(json);
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                         self.secretAccessKey, self.region,
                                                                         POST, self.uri, target, payload);
        TableList response = check self.httpClient->post(self.uri,payload, signedRequestHeaders);
        self.exclusiveStartTableName = response?.LastEvaluatedTableName;
        string[]? tableList = response?.TableNames;
        if tableList is string[] {
            return tableList;
        }
        return [];
    }
}
