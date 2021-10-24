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

import ballerina/io;
import ballerina/test;
import ballerina/log;
import ballerina/lang.runtime;
import ballerina/os;

configurable string accessKeyId = os:getEnv("ACCESS_KEY_ID");
configurable string secretAccessKey = os:getEnv("SECRET_ACCESS_KEY");
configurable string region = os:getEnv("REGION");

final string mainTable = "Thread";
final string secondaryTable = "SecondaryThread";

ConnectionConfig config = {
    awsCredentials: {accessKeyId: accessKeyId, secretAccessKey: secretAccessKey},
    region: region
};

Client dynamoDBClient = check new (config);

@test:Config {}
function testCreateTable() returns error?{
    TableCreationRequest payload = {
        AttributeDefinitions: [
            {
                AttributeName: "ForumName",
                AttributeType: "S"
            },
            {
                AttributeName: "Subject",
                AttributeType: "S"
            },
            {
                AttributeName: "LastPostDateTime",
                AttributeType: "S"
            }
        ],
        TableName: mainTable,
        KeySchema: [
            {
                AttributeName: "ForumName",
                KeyType: HASH
            },
            {
                AttributeName: "Subject",
                KeyType: RANGE
            }
        ],
        LocalSecondaryIndexes: [
            {
                IndexName: "LastPostIndex",
                KeySchema: [
                    {
                        AttributeName: "ForumName",
                        KeyType: HASH
                    },
                    {
                        AttributeName: "LastPostDateTime",
                        KeyType: RANGE
                    }
                ],
                Projection: {
                    ProjectionType: KEYS_ONLY
                }
            }
        ],
        ProvisionedThroughput: {
            ReadCapacityUnits: 5,
            WriteCapacityUnits: 5
        },
        Tags: [
            {
                Key: "Owner",
                Value: "BlueTeam"
            }
        ]
    };
    TableResponse createTablesResult = check dynamoDBClient->createTable(payload);
    test:assertEquals(createTablesResult.TableDescription?.TableName, mainTable, "Expected table is not created.");
    test:assertEquals(createTablesResult.TableDescription?.TableStatus, CREATING, "Table is not created.");
    payload.TableName = secondaryTable;
    createTablesResult = check dynamoDBClient->createTable(payload);
    log:printInfo(createTablesResult.TableDescription?.TableName.toString());
    runtime:sleep(20);
    log:printInfo("Testing CreateTable is completed.");
}

@test:Config{
    dependsOn: [testCreateTable]
}
function testDescribeTable() returns error?{
    TableDescriptionResponse response = check dynamoDBClient->describeTable(mainTable);
    test:assertEquals(response.Table?.TableName, mainTable, "Expected table is not described.");
    log:printInfo("Testing DescribeTable is completed.");
}

@test:Config{
    dependsOn: [testDescribeTable]
}
function testUpdateTable() returns error? {
    TableUpdateRequest request = {
        TableName: mainTable,
        ProvisionedThroughput: {
            ReadCapacityUnits: 10,
            WriteCapacityUnits: 10
        }
    };
    TableResponse response = check dynamoDBClient->updateTable(request);
    ProvisionedThroughputDescription? provisionedThroughput = response.TableDescription?.ProvisionedThroughput;
    if provisionedThroughput !is () {
        test:assertEquals(provisionedThroughput?.ReadCapacityUnits, 5, "Read Capacity Units are not updated in table");
        test:assertEquals(provisionedThroughput?.WriteCapacityUnits, 5, "Write Capacity Units are not updated in table");
    }
    log:printInfo("Testing UpdateTable is completed.");
}

@test:Config {
    dependsOn: [testUpdateTable]
}
function testListTables() returns error?{
    TableListingRequest request = {
        Limit: 10
    };
    stream<string, error?> response = check dynamoDBClient->listTables();
    io:println(response);
    test:assertTrue(response.next() is record {| string value; |}, "Expected result is not obtained");
    check response.forEach(function(string tableName){
        log:printInfo(tableName);
    });
    log:printInfo("Testing ListTables is completed.");
}
// @test:Config{}
// function testDeleteTable() returns error? {
//     TableResponse response = check dynamoDBClient->deleteTable("Thread2");
//     io:println(response);
//     io:println(response.TableDescription?.TableName);
//     io:println(response.TableDescription?.TableStatus);
// }

@test:Config{
    dependsOn: [testListTables]
}
function testCreateItem() returns error? {
    ItemCreationRequest request = {
        TableName: mainTable,
        Item: {
            "LastPostDateTime" : {
                "S": "201303190422"
            },
            "Tags": {
                "SS": [
                    "Update",
                    "Multiple Items",
                    "HelpMe"
                ]
            },
            "ForumName": {
                "S": "Amazon DynamoDB"
            },
            "Message": {
                "S": "I want to update multiple items in a single call. What's the best way to do that?"
            },
            "Subject": {
                "S": "How do I update multiple items?"
            },
            "LastPostedBy": {
                "S": "fred@example.com"
            }
        },
        ConditionExpression: "ForumName <> :f and Subject <> :s",
        ReturnValues: ALL_OLD,
        ReturnItemCollectionMetrics: SIZE,
        ReturnConsumedCapacity: TOTAL,
        ExpressionAttributeValues: {
            ":f": {
                "S": "Amazon DynamoDB"
            },
            ":s": {
                "S": "How do I update multiple items?"
            }
        }
    };

    ItemDescription response = check dynamoDBClient->createItem(request);
    log:printInfo(response.toString());
    log:printInfo("Testing CreateItem is completed.");
}

@test:Config{
    dependsOn: [testCreateItem]
}
function testGetItem() returns error? {
    GetItemRequest request = {
        TableName: mainTable,
        Key: {
            "ForumName": {
            "S": "Amazon DynamoDB"
            },
            "Subject": {
            "S": "How do I update multiple items?"
            }
        },
        ProjectionExpression: "LastPostDateTime, Message, Tags",
        ConsistentRead: true,
        ReturnConsumedCapacity: TOTAL
    };
    GetItemResponse response = check dynamoDBClient->getItem(request);
    log:printInfo(response?.Item.toString());
    log:printInfo("Testing GetItem is completed.");
}

@test:Config{
    dependsOn: [testGetItem]
}
function testUpdateItem() returns error? {
    ItemUpdateRequest request = {
        TableName: mainTable,
        Key: {
            "ForumName": {
                "S": "Amazon DynamoDB"
            },
            "Subject": {
                "S": "How do I update multiple items?"
            }
        },
        UpdateExpression: "set LastPostedBy = :val1",
        ConditionExpression: "LastPostedBy = :val2",
        ExpressionAttributeValues: {
            ":val1": {
                "S": "alice@example.com"
            },
            ":val2": {
                "S": "fred@example.com"
            }
        },
        ReturnValues: ALL_NEW,
        ReturnConsumedCapacity: TOTAL,
        ReturnItemCollectionMetrics: SIZE
    };
    ItemDescription response = check dynamoDBClient->updateItem(request);
    log:printInfo(response.toString());
    log:printInfo("Testing UpdateItem is completed.");
}

@test:Config{
    dependsOn: [testUpdateItem]
}
function testQuery() returns error? {
    QueryRequest request = {
        TableName: mainTable,
        ConsistentRead: true,
        KeyConditionExpression: "ForumName = :val",
        ExpressionAttributeValues: {":val": {"S": "Amazon DynamoDB"}}
    };
    QueryOrScanResponse response = check dynamoDBClient->query(request);
    log:printInfo(response.toString());
    log:printInfo("Testing Query is completed.");
}
@test:Config{
    dependsOn: [testQuery]
}
function testScan() returns error? {
    ScanRequest request = {
        TableName: mainTable,
        FilterExpression: "LastPostedBy = :val",
        ExpressionAttributeValues: {":val": {"S": "alice@example.com"}},
        ReturnConsumedCapacity: TOTAL
    };

    QueryOrScanResponse response = check dynamoDBClient->scan(request);
    log:printInfo(response.toString());
    log:printInfo("Testing Scan is completed.");
}
@test:Config{
    dependsOn: [testScan]
}
function testBatchWriteItem() returns error? {
    TableDescriptionResponse tableResponse = check dynamoDBClient->describeTable(secondaryTable);
    log:printInfo(tableResponse.Table?.TableName.toString());
    BatchWriteItemRequest request = {
        RequestItems: {
            secondaryTable :[
                {
                    PutRequest: {
                        "Item": {
                            "LastPostDateTime": {
                                "S": "201303190423"
                            },
                            "Tags": {
                                "SS": [
                                        "Update",
                                        "Multiple Items",
                                        "HelpMe"
                                    ]
                                },
                            "ForumName": {
                                    "S": "Amazon s3"
                                },
                            "Message": {
                                    "S": "I want to update multiple items in a single call. What's the best way to do that?"
                                },
                            "Subject": {
                                    "S": "How do I update multiple items0?"
                                },
                            "LastPostedBy": {
                                    "S": "fred0@example.com"
                                }
                            }
                        }
                    },
                {
                    PutRequest: {
                        "Item": {
                            "LastPostDateTime": {
                                "S": "201303190423"
                            },
                            "Tags": {
                                "SS": [
                                        "Update",
                                        "Multiple Items",
                                        "HelpMe"
                                    ]
                                },
                            "ForumName": {
                                    "S": "Amazon DynamoDB"
                                },
                            "Message": {
                                    "S": "I want to update multiple items in a single call. What's the best way to do that?"
                                },
                            "Subject": {
                                    "S": "How do I update multiple items1?"
                                },
                            "LastPostedBy": {
                                    "S": "fred@example.com"
                                }
                            }
                        }
                    },
                {
                    PutRequest: {
                        "Item": {
                            "LastPostDateTime": {
                                "S": "201303190423"
                            },
                            "Tags": {
                                "SS": [
                                        "Update",
                                        "Multiple Items",
                                        "HelpMe"
                                    ]
                                },
                            "ForumName": {
                                    "S": "Amazon SimpleDB"
                                },
                            "Message": {
                                    "S": "I want to update multiple items in a single call. What's the best way to do that?"
                                },
                            "Subject": {
                                    "S": "How do I update multiple items1?"
                                },
                            "LastPostedBy": {
                                    "S": "fred1@example.com"
                                }
                            }
                        }
                    },
                {
                    PutRequest: {
                        "Item": {
                            "LastPostDateTime": {
                                "S": "201303190423"
                            },
                            "Tags": {
                                "SS": [
                                        "Update",
                                        "Multiple Items",
                                        "HelpMe"
                                    ]
                                },
                            "ForumName": {
                                    "S": "Amazon SES"
                                },
                            "Message": {
                                    "S": "I want to update multiple items in a single call. What's the best way to do that?"
                                },
                            "Subject": {
                                    "S": "How do I update multiple items2?"
                                },
                            "LastPostedBy": {
                                    "S": "fred2@example.com"
                                }
                            }
                        }                                                                     
                    }
            ]
        },
        ReturnConsumedCapacity: TOTAL
    };

    BatchWriteItemResponse response = check dynamoDBClient->batchWriteItem(request);
    log:printInfo(response.toString());
    log:printInfo("Testing BatchWriteItem (put) is completed.");
}
@test:Config{
    dependsOn: [testBatchWriteItem]
}
function testBatchGetItem() returns error? {
    BatchGetItemRequest request = {
        RequestItems: {
            mainTable: {
                Keys: [
                    {
                        "ForumName":{"S":"Amazon DynamoDB"},
                        "Subject":{"S":"How do I update multiple items?"}
                    }
                ],
                ProjectionExpression:"Tags, Message"
            },
            secondaryTable: {
                Keys: [
                    {
                        "ForumName":{"S":"Amazon DynamoDB123"},
                        "Subject":{"S":"How do I update multiple items123?"}
                    }
                ],
                ProjectionExpression:"Tags, Message,LastPostedBy"
            }
        },
        ReturnConsumedCapacity: TOTAL
    };

    BatchGetItemResponse response = check dynamoDBClient->batchGetItem(request);
    log:printInfo(response.toString());
    log:printInfo("Testing BatchGetItem is completed.");
}
@test:Config{
    dependsOn: [testBatchGetItem]
}
function testDeleteItem() returns error? {
    ItemDeletionRequest request = {
        TableName: mainTable,
        Key: {
            "ForumName": {
                "S": "Amazon DynamoDB"
            },
            "Subject": {
                "S": "How do I update multiple items?"
            }
        },
        ReturnConsumedCapacity: TOTAL,
        ReturnItemCollectionMetrics: SIZE,
        ReturnValues: ALL_OLD
    };
    ItemDescription response = check dynamoDBClient->deleteItem(request);
    io:println(response);
    io:println(response?.Attributes);
    io:println(response?.ConsumedCapacity);
    io:println(response?.ItemCollectionMetrics);
}



@test:Config{}
function testDescribeLimits() returns error? {
    LimitDescribtion response = check dynamoDBClient->describeLimits();
    io:println(response);
    io:println(response?.AccountMaxReadCapacityUnits);
}
// // Negative Test function

// @test:Config {}
// function negativeTestFunction() {
//     string name = "";
//     string welcomeMsg = hello(name);
//     test:assertEquals("Hello, World!", welcomeMsg);
// }

// // After Suite Function

@test:AfterSuite
function testDeleteTable() returns error? {
    TableResponse response = check dynamoDBClient->deleteTable(mainTable);
    io:println(response);
    io:println(response.TableDescription?.TableName);
    io:println(response.TableDescription?.TableStatus);
    response = check dynamoDBClient->deleteTable(secondaryTable);
    io:println(response);
    io:println(response.TableDescription?.TableName);
    io:println(response.TableDescription?.TableStatus);
}
