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

# Represents AWS client configuration.
#
# + awsCredentials - AWS credentials  
# + region - AWS region  
public type ConnectionConfig record {
    AwsCredentials|AwsTemporaryCredentials awsCredentials;
    string region;
};

# Represents AWS credentials.
#
# + accessKeyId - AWS access key  
# + secretAccessKey - AWS secret key
public type AwsCredentials record {
    string accessKeyId;
    string secretAccessKey;
};

# Represents AWS temporary credentials.
#
# + accessKeyId - AWS access key  
# + secretAccessKey - AWS secret key  
# + securityToken - AWS secret token
public type AwsTemporaryCredentials record {
    string accessKeyId;
    string secretAccessKey;
    string securityToken;   
};


//AWS

public type LimitDescribtion record {
    int? AccountMaxReadCapacityUnits?;
    int? AccountMaxWriteCapacityUnits?;
    int? TableMaxReadCapacityUnits?;
    int? TableMaxWriteCapacityUnits?;
};
public type BatchWriteItemResponse record {
    ConsumedCapacity[]? ConsumedCapacity?;
    map<ItemCollectionMetrics[]>? ItemCollectionMetrics?;
    map<WriteRequest[]>? UnprocessedItems?;
};

public type BatchWriteItemRequest record {
    map<WriteRequest[]> RequestItems;
    ReturnConsumedCapacity ReturnConsumedCapacity?;
    ReturnItemCollectionMetrics ReturnItemCollectionMetrics?;
};

public type BatchGetItemResponse record {
    ConsumedCapacity[]? ConsumedCapacity?;
    map<map<AttributeValue>[]>? Responses?;
    map<KeysAndAttributes>? UnprocessedKeys?;
};

public type BatchGetItemRequest record {
    map<KeysAndAttributes> RequestItems;
    ReturnConsumedCapacity ReturnConsumedCapacity?;
};
public type ScanRequest record {
    string TableName;
    string[] AttributesToGet?;
    ConditionalOperator ConditionalOperator?;
    boolean ConsistentRead?;
    map<AttributeValue> ExclusiveStartKey?;
    map<string> ExpressionAttributeNames?;
    map<AttributeValue> ExpressionAttributeValues?;
    string FilterExpression?;
    string IndexName?;
    int Limit?;
    string ProjectionExpression?;
    ReturnConsumedCapacity ReturnConsumedCapacity?;
    map<Condition> ScanFilter?;
    int Segment?;
    Select Select?;
    int TotalSegments?;
};

public type QueryOrScanResponse record {
    ConsumedCapacity? ConsumedCapacity?;
    int? Count?;
    map<AttributeValue>[]? Items?;
    map<AttributeValue>? LastEvaluatedKey?;
    int? ScannedCount?;
};
public type QueryRequest record {
    string TableName;
    string[] AttributesToGet?;
    ConditionalOperator ConditionalOperator?;
    boolean ConsistentRead?;
    map<AttributeValue> ExclusiveStartKey?;
    map<string> ExpressionAttributeNames?;
    map<AttributeValue> ExpressionAttributeValues?;
    string FilterExpression?;
    string IndexName?;
    string KeyConditionExpression?;
    map<Condition> KeyConditions?;
    int Limit?;
    string ProjectionExpression?;
    map<Condition> QueryFilter?;
    ReturnConsumedCapacity ReturnConsumedCapacity?;
    boolean ScanIndexForward?;
    Select Select?;
};
public type ItemUpdateRequest record {
    map<AttributeValue> Key;
    string TableName;
    map<AttributeValueUpdate> AttributeUpdates?;
    ConditionalOperator ConditionalOperator?;
    string ConditionExpression?;
    map<ExpectedAttributeValue> Expected?;
    map<string> ExpressionAttributeNames?;
    map<AttributeValue> ExpressionAttributeValues?;
    ReturnConsumedCapacity ReturnConsumedCapacity?;
    ReturnItemCollectionMetrics ReturnItemCollectionMetrics?;
    ReturnValues ReturnValues?;
    string UpdateExpression?;
};

public type ItemDeletionRequest record {
    map<AttributeValue> Key;
    string TableName;
    ConditionalOperator ConditionalOperator?;
    string ConditionExpression?;
    map<ExpectedAttributeValue> Expected?;
    map<string> ExpressionAttributeNames?;
    map<AttributeValue> ExpressionAttributeValues?;
    ReturnConsumedCapacity ReturnConsumedCapacity?;
    ReturnItemCollectionMetrics ReturnItemCollectionMetrics?;
    ReturnValues ReturnValues?;
};

public type GetItemResponse record {
    ConsumedCapacity? ConsumedCapacity?;
    map<AttributeValue>? Item?;
};

public type GetItemRequest record {
    map<AttributeValue> Key;
    string TableName;
    string[] AttributesToGet?;
    boolean ConsistentRead?;
    map<string> ExpressionAttributeNames?;
    string ProjectionExpression?;
    ReturnConsumedCapacity ReturnConsumedCapacity?;
};
public type ItemDescription record {
    map<AttributeValue>? Attributes?;
    ConsumedCapacity? ConsumedCapacity?;
    ItemCollectionMetrics? ItemCollectionMetrics?;
};
public type ItemCreationRequest record {
    map<AttributeValue> Item;
    string TableName;
    ConditionalOperator ConditionalOperator?;
    string ConditionExpression?;
    map<ExpectedAttributeValue> Expected?;
    map<string> ExpressionAttributeNames?;
    map<AttributeValue> ExpressionAttributeValues?;
    ReturnConsumedCapacity ReturnConsumedCapacity?;
    ReturnItemCollectionMetrics ReturnItemCollectionMetrics?;
    ReturnValues ReturnValues?;
};
public type TableUpdateRequest record {
    string TableName;
    AttributeDefinition[] AttributeDefinitions?;
    BillingMode BillingMode?;
    GlobalSecondaryIndexUpdate[] GlobalSecondaryIndexUpdates?;
    ProvisionedThroughput ProvisionedThroughput?;
    ReplicationGroupUpdate[] ReplicaUpdates?;
    SSESpecification SSESpecification?;
    StreamSpecification StreamSpecification?;
};
public type TableListingRequest record {
    string? ExclusiveStartTableName?;
    int? Limit?;
};

public type TableList record {
    string LastEvaluatedTableName?;
    string[] TableNames?;
};
public type TableResponse record {
    TableDescription TableDescription;
};
public type TableDescriptionResponse record {
    TableDescription Table;
};
public type TableCreationRequest record {
    AttributeDefinition[] AttributeDefinitions;
    KeySchemaElement[] KeySchema;
    string TableName;
    BillingMode BillingMode?;
    GlobalSecondaryIndex[] GlobalSecondaryIndexes?;
    LocalSecondaryIndex[] LocalSecondaryIndexes?;
    ProvisionedThroughput ProvisionedThroughput?;
    SSESpecification SSESpecification?;
    StreamSpecification StreamSpecification?;
    Tag[] Tags?;
};
//============================================
public type AttributeDefinition record {
    string AttributeName;
    AttributeType AttributeType;
};

public type KeySchemaElement record {
    string AttributeName;
    KeyType KeyType;
};

public type Projection record {
    string[]? NonKeyAttributes?;
    ProjectionType? ProjectionType?;
};

public type ProvisionedThroughput record {
    int ReadCapacityUnits;
    int WriteCapacityUnits;
};

public type LocalSecondaryIndex record {
    string IndexName;
    KeySchemaElement[] KeySchema;
    Projection Projection;
};
public type GlobalSecondaryIndex record {
    *LocalSecondaryIndex;
    ProvisionedThroughput ProvisionedThroughput;
};

public type SSESpecification record {
    boolean? Enabled?;
    string? KMSMasterKeyId?;
    SSEType? SSEType?;
};

public type StreamSpecification record {
    boolean StreamEnabled;
    StreamViewType? StreamViewType?;
};

public type Tag record {
    string Key;
    string Value;
};

public type ArchivalSummary record {
    string? ArchivalBackupArn?;
    int? ArchivalDateTime?;
    string? ArchivalReason?;
};

public type BillingModeSummary record {
    BillingMode? BillingMode?;
    int? LastUpdateToPayPerRequestDateTime?;
};

public type GlobalSecondaryIndexDescription record {
    *LocalSecondaryIndexDescription;
    boolean? Backfilling?;
    IndexStatus? IndexStatus?;
    ProvisionedThroughput? ProvisionedThroughput?;
};

public type LocalSecondaryIndexDescription record {
    string? IndexArn?;
    string? IndexName?;
    int? IndexSizeBytes?;
    int? ItemCount?;
    KeySchemaElement[]? KeySchema?;
    Projection? Projection?;
};

public type ProvisionedThroughputDescription record {
    int? LastDecreaseDateTime?;
    int? LastIncreaseDateTime?;
    int? NumberOfDecreasesToday?;
    int? ReadCapacityUnits?;
    int? WriteCapacityUnits?;
};

public type ProvisionedThroughputOverride record {
    int? ReadCapacityUnits?;
};
public type ReplicaGlobalSecondaryIndexDescription record {
    string? IndexName?;
    ProvisionedThroughputOverride? ProvisionedThroughputOverride?;
};
public type ReplicaDescription record {
    ReplicaGlobalSecondaryIndexDescription[]? GlobalSecondaryIndexes?;
    string? KMSMasterKeyId?;
    ProvisionedThroughputOverride? ProvisionedThroughputOverride?;
    string? RegionName?;
    int? ReplicaInaccessibleDateTime?;
    ReplicaStatus? ReplicaStatus?;
    string? ReplicaStatusDescription?;
    string? ReplicaStatusPercentProgress?;
};

public type RestoreSummary record {
    int RestoreDateTime;
    boolean RestoreInProgress;
    string? SourceBackupArn?;
    string? SourceTableArn?;
};

public type SSEDescription record {
    int? InaccessibleEncryptionDateTime?;
    string? KMSMasterKeyArn?;
    SSEType? SSEType?;
    Status? Status?;
};

public type TableDescription record {
    ArchivalSummary? ArchivalSummary?;
    AttributeDefinition[]? AttributeDefinitions?;
    BillingModeSummary? BillingModeSummary?;
    int? CreationDateTime?;
    GlobalSecondaryIndexDescription[]? GlobalSecondaryIndexes?;
    string? GlobalTableVersion?;
    int? ItemCount?;
    KeySchemaElement[]? KeySchema?;
    string? LatestStreamArn?;
    string? LatestStreamLabel?;
    LocalSecondaryIndexDescription[]? LocalSecondaryIndexes?;
    ProvisionedThroughputDescription? ProvisionedThroughput?;
    ReplicaDescription[]? Replicas?;
    RestoreSummary? RestoreSummary?;
    SSEDescription? SSEDescription?;
    StreamSpecification? StreamSpecification?;
    string? TableArn?;
    string? TableId?;
    string? TableName?;
    int? TableSizeBytes?;
    TableStatus? TableStatus?;
};

public type CreateGlobalSecondaryIndexAction record {
    string IndexName;
    KeySchemaElement[] KeySchema;
    Projection Projection;
    ProvisionedThroughput? ProvisionedThroughput?;
};

public type DeleteGlobalSecondaryIndexAction record {
    string IndexName;
};

public type UpdateGlobalSecondaryIndexAction record {
    string IndexName;
    ProvisionedThroughput ProvisionedThroughput;
};

public type GlobalSecondaryIndexUpdate record {
    CreateGlobalSecondaryIndexAction? Create?;
    DeleteGlobalSecondaryIndexAction? Delete?;
    UpdateGlobalSecondaryIndexAction? Update?;
};

public type ReplicaGlobalSecondaryIndex record {
    string IndexName;
    ProvisionedThroughputOverride? ProvisionedThroughputOverride?;
};

public type CreateReplicationGroupMemberAction record {
    string RegionName;
    ReplicaGlobalSecondaryIndex[]? GlobalSecondaryIndexes?;
    string? KMSMasterKeyId?;
    ProvisionedThroughputOverride? ProvisionedThroughputOverride?;
};

public type DeleteReplicationGroupMemberAction record {
    string RegionName;
};

public type UpdateReplicationGroupMemberAction record {
    *CreateReplicationGroupMemberAction;
};

public type ReplicationGroupUpdate record {
    CreateReplicationGroupMemberAction? Create?;
    DeleteReplicationGroupMemberAction? Delete?;
    UpdateReplicationGroupMemberAction? Update?;
};

//Need to modify/check again.
public type AttributeValue record {
    string? B? ; // Base64-encoded binary data object B?;
    boolean? BOOL?;
    string[]? BS?; // Type: Array of Base64-encoded binary data objects BS?;
    AttributeValue[]? L?;
    map<AttributeValue>? M?;// String to AttributeValue (p. 332) object map M?;
    string? N?;
    string[]? NS?;
    boolean? NULL?;
    string? S?;
    string[]? SS?;
};

//Need to check optional
public type ExpectedAttributeValue record {
    AttributeValue[]? AttributeValueList?;
    ComparisonOperator? ComparisonOperator?;
    boolean? Exists?;
    AttributeValue? Value?;
};

public type Capacity record {
    float? CapacityUnits?;
    float? ReadCapacityUnits?;
    float? WriteCapacityUnits?;
};
public type ConsumedCapacity record {
    float? CapacityUnits?;
    map<Capacity>? GlobalSecondaryIndexes?;
    map<Capacity>? LocalSecondaryIndexes?;
    float? ReadCapacityUnits?;
    Capacity? Table?;
    string? TableName?;
    float? WriteCapacityUnits?;
};

public type ItemCollectionMetrics record {
    map<AttributeValue>? ItemCollectionKey?;
    float[]? SizeEstimateRangeGB?;
};

public type AttributeValueUpdate record {
    Action? Action?;
    AttributeValue? Value?;
};

public type Condition record {
    ComparisonOperator ComparisonOperator;
    AttributeValue[]? AttributeValueList?;
};

public type KeysAndAttributes record {
    map<AttributeValue>[] Keys;
    string[]? AttributesToGet?;
    boolean? ConsistentRead?;
    map<string>? ExpressionAttributeNames?;
    string? ProjectionExpression?;
};

public type DeleteRequest record {
    map<AttributeValue> Key;
};

public type PutRequest record {
    map<AttributeValue> Item;
};

public type WriteRequest record {
    DeleteRequest? DeleteRequest?;
    PutRequest? PutRequest?;
};