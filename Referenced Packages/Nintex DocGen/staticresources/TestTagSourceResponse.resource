{
    "types": [
        {
            "name": "IntegrationContact",
            "label": "FRIENDLY CONTACT",
            "fields": [
                {
                    "name": "Id",
                    "label": "FRIENDLY CONTACT ID",
                    "type": "String"
                },
                {
                    "name": "Account",
                    "label": "FRIENDLY CONTACT ACCOUNT",
                    "type": "Reference",
                    "referenceType": "IntegrationAccount"
                }
            ]
        },
        {
            "name": "IntegrationAccount",
            "label": "FRIENDLY NAME",
            "fields": [
                {
                    "name": "Id",
                    "label": "FRIENDLY ACCOUNT ID",
                    "type": "String"
                },
                {
                    "name": "PrimaryContact",
                    "label": "FRIENDLY ACCOUNT PrimaryContact",
                    "type": "Reference",
                    "referenceType": "IntegrationContact"
                },
                {
                    "name": "SecondaryContact",
                    "label": "FRIENDLY ACCOUNT SecondaryContact",
                    "type": "Reference",
                    "referenceType": "IntegrationContact"
                }
            ]
        }
    ],
    "relationships": [
        {
            "name": "c1",
            "label": "Contact 1",
            "type": "IntegrationContact"
        },
        {
            "name": "c2",
            "label": "Contact 2",
            "type": "IntegrationContact"
        },
        {
            "name": "Account",
            "label": "Account",
            "type": "IntegrationAccount",
            "children": [
            {
                "name": "ACL1",
                "label": "Account Contact List 1",
                "type": "IntegrationContact"
            },
            {
                "name": "ACL2",
                "label": "Account Contact List 2",
                "type": "IntegrationContact"
            },
            {
                "name": "Contacts",
                "label": "Contact List",
                "type": "IntegrationContact"
            }
            ]
        }
    ]
}