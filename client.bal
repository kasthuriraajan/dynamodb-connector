// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
public isolated client class Client {
    private final http:Client awsDynamoDb;
    private final string accessKeyId;
    private final string secretAccessKey;
    private final string? securityToken;
    private final string region;
    private final string awsHost;
    private final string uri = SLASH;

    public isolated function init(ConnectionConfig awsDynamodbConfig, http:ClientConfiguration httpConfig ={})
                                  returns error? {
        self.accessKeyId = awsDynamodbConfig.awsCredentials.accessKeyId;
        self.secretAccessKey = awsDynamodbConfig.awsCredentials.secretAccessKey;
        self.securityToken = awsDynamodbConfig.awsCredentials?.securityToken;
        self.region = awsDynamodbConfig.region;
        self.awsHost = AWS_SERVICE + DOT + self.region + DOT + AWS_HOST;
        string endpoint = HTTPS + self.awsHost;
        self.awsDynamoDb = check new(endpoint, httpConfig);
    }

    remote isolated function createTable(TableCreationRequest tableCreationRequest) returns TableResponse|error {
        string target = VERSION + DOT + "CreateTable";
        json payload = check tableCreationRequest.cloneWithType(json);
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                         self.secretAccessKey, self.region,
                                                                         POST, self.uri, target, payload);

        TableResponse response = check self.awsDynamoDb->post(self.uri, payload, signedRequestHeaders);                                                     
        return response;
    }

    remote isolated function deleteTable(string tableName) returns TableResponse|error {
        string target = VERSION + DOT + "DeleteTable";
        json payload = {
           "TableName": tableName 
        };

        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                         self.secretAccessKey, self.region,
                                                                         POST, self.uri, target, payload);
        TableResponse response = check self.awsDynamoDb->post(self.uri, payload, signedRequestHeaders);
        return response;
    }

    remote isolated function describeTable(string tableName) returns TableDescriptionResponse|error {
        string target = VERSION + DOT + "DescribeTable";
        json payload = {
            "TableName": tableName
        };

        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                         self.secretAccessKey, self.region,
                                                                         POST, self.uri, target, payload);
        TableDescriptionResponse response = check self.awsDynamoDb->post(self.uri, payload, signedRequestHeaders);
        return response;
    }
    
    remote isolated function listTables (string? exclusiveStartTableName = (), int? 'limit = ())
                                         returns stream<string, error?>|error {
        TableStream tableStream = check new TableStream(self.awsDynamoDb, self.awsHost, self.accessKeyId,
                                                        self.secretAccessKey, self.region, exclusiveStartTableName,
                                                        'limit);
        return new stream<string,error?>(tableStream);
    }

    remote isolated function updateTable(TableUpdateRequest tableUpdateRequest) returns TableResponse|error {
        string target = VERSION + DOT + "UpdateTable";
        json payload = check tableUpdateRequest.cloneWithType(json);
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                         self.secretAccessKey, self.region,
                                                                         POST, self.uri, target, payload);
        TableResponse response = check self.awsDynamoDb->post(self.uri, payload, signedRequestHeaders);
        return response;
    }

    //need to revise function name
    remote isolated function createItem(ItemCreationRequest request) returns ItemDescription|error {
        string target = VERSION + DOT + "PutItem";
        json payload = check request.cloneWithType(json);
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                         self.secretAccessKey, self.region,
                                                                         POST, self.uri, target, payload);
        ItemDescription response = check self.awsDynamoDb->post(self.uri, payload, signedRequestHeaders);
        return response;                                                                 
    }

    remote isolated function getItem(GetItemRequest request) returns GetItemResponse|error {
        string target = VERSION + DOT + "GetItem";
        json payload = check request.cloneWithType(json);
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                         self.secretAccessKey, self.region,
                                                                         POST, self.uri, target, payload);
        GetItemResponse response = check self.awsDynamoDb->post(self.uri, payload, signedRequestHeaders);
        return response;                                                                 
    }

    remote isolated function deleteItem(ItemDeletionRequest request) returns ItemDescription|error {
        string target = VERSION + DOT + "DeleteItem";
        json payload = check request.cloneWithType(json);
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                         self.secretAccessKey, self.region,
                                                                         POST, self.uri, target, payload);
        ItemDescription response = check self.awsDynamoDb->post(self.uri, payload, signedRequestHeaders);
        return response;                                                                 
    }

    remote isolated function updateItem(ItemUpdateRequest request) returns ItemDescription|error {
        string target = VERSION + DOT + "UpdateItem";
        json payload = check request.cloneWithType(json);
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                         self.secretAccessKey, self.region,
                                                                         POST, self.uri, target, payload);
        ItemDescription response = check self.awsDynamoDb->post(self.uri, payload, signedRequestHeaders);
        return response;
    }

    remote isolated function query(QueryRequest request) returns QueryOrScanResponse|error {
        string target = VERSION + DOT + "Query";
        json payload = check request.cloneWithType(json);
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                         self.secretAccessKey, self.region,
                                                                         POST, self.uri, target, payload);
        QueryOrScanResponse response = check self.awsDynamoDb->post(self.uri, payload, signedRequestHeaders);
        return response;                                                              
    }

    remote isolated function scan(ScanRequest request) returns QueryOrScanResponse|error {
        string target = VERSION + DOT + "Scan";
        json payload = check request.cloneWithType(json);
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                         self.secretAccessKey, self.region,
                                                                         POST, self.uri, target, payload);
        QueryOrScanResponse response = check self.awsDynamoDb->post(self.uri, payload, signedRequestHeaders);
        return response;                                                              
    }

    remote isolated function batchGetItem(BatchGetItemRequest request) returns BatchGetItemResponse|error {
        string target = VERSION + DOT + "BatchGetItem";
        json payload = check request.cloneWithType(json);
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                         self.secretAccessKey, self.region,
                                                                         POST, self.uri, target, payload);
        BatchGetItemResponse response = check self.awsDynamoDb->post(self.uri, payload, signedRequestHeaders);
        return response;
    }

    remote isolated function batchWriteItem(BatchWriteItemRequest request) returns BatchWriteItemResponse|error {
        string target = VERSION + DOT + "BatchWriteItem";
        json payload = check request.cloneWithType(json);
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                         self.secretAccessKey, self.region,
                                                                         POST, self.uri, target, payload);
        BatchWriteItemResponse response = check self.awsDynamoDb->post(self.uri, payload, signedRequestHeaders);
        return response;
    }

    remote isolated function describeLimits() returns LimitDescribtion|error {
        string target = VERSION + DOT +"DescribeLimits";
        json payload = {};
        map<string> signedRequestHeaders = check getSignedRequestHeaders(self.awsHost, self.accessKeyId,
                                                                         self.secretAccessKey, self.region,
                                                                         POST, self.uri, target, payload);
        LimitDescribtion response = check self.awsDynamoDb->post(self.uri, payload, signedRequestHeaders);
        return response;
    }

}
