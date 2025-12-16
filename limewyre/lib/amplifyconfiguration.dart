const amplifyconfig = '''
  {
    "UserAgent": "aws-amplify-cli/2.0",
    "Version": "1.0",
    "api": {
        "plugins": {
            "awsAPIPlugin": {
                "cardio_cognetics_mobile_users_live": {
                    "endpointType": "GraphQL",
                    "endpoint": "https://pzr4yixttbdijfgc75vuh746qq.appsync-api.us-east-1.amazonaws.com/graphql",
                    "region": "us-east-1",
                    "authorizationType": "AMAZON_COGNITO_USER_POOLS"
                }
            }
        }
    },
    "storage": {
    "plugins": {
      "awsS3StoragePlugin": {
        "bucket": "limewyre",
        "region": "us-east-1"
      }
    }
  },    
    "auth": {
        "plugins": {
            "awsCognitoAuthPlugin": {
                "UserAgent": "aws-amplify-cli/0.1.0",
                "Version": "0.1.0",
                "IdentityManager": {
                    "Default": {}
                },
                 "CredentialsProvider": {
                   "CognitoIdentity": {
                     "Default": {
                       "PoolId": "us-east-1:88c84f92-8083-4566-9e26-d44662bf4044",
                       "Region": "us-east-1"
                     }
                   }
                 },
                "CognitoUserPool": {
                    "Default": {
                        "PoolId": "us-east-1_jo21jm5Gv",
                        "AppClientId": "k7jqsg5iloe9bdeeas4f6r8n1",
                        "Region": "us-east-1"
                    }
                },
                "Auth": {
                    "Default": {
                        "authenticationFlowType": "CUSTOM_AUTH",
                        "usernameAttributes": [
                            "EMAIL"
                        ],
                        "signupAttributes": [
                            "EMAIL"
                        ],
                        "passwordProtectionSettings": {
                            "passwordPolicyMinLength": 8,
                            "passwordPolicyCharacters": []
                        },
                        "mfaConfiguration": "OFF",
                        "mfaTypes": [
                            "SMS"
                        ],
                        "verificationMechanisms": [
                            "EMAIL"
                        ]
                    }
                }

            }
        }
    }
  }
  ''';
