/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class ProcessDdpParameters {
    global List<Id> additionalRecordIds {
        get;
    }
    global List<Loop.AdHoc.Attachment> attachments {
        get;
        set;
    }
    global Boolean attachToRecord {
        get;
        set;
    }
    global Id ddpId {
        get;
    }
    global Id deliveryOptionId {
        get;
    }
    global String onCompleteCallback {
        get;
        set;
    }
    global String onErrorCallback {
        get;
        set;
    }
    global String onProgressCallback {
        get;
        set;
    }
    global List<Id> optionalDdpFileIds {
        get;
        set;
    }
    global String previewButtonText {
        get;
        set;
    }
    global Id recordId {
        get;
    }
    global Loop.ProcessDdpParameters.ThemeStyle theme {
        get;
        set;
    }
    global Boolean usePreview {
        get;
        set;
    }
    global Id workspaceId {
        get;
        set;
    }
    global ProcessDdpParameters(Id ddpId, Id deliveryOptionId, Id recordId, List<Id> additionalRecordIds) {

    }
    global ProcessDdpParameters(Id ddpId, Id deliveryOptionId, Id recordId, List<Id> additionalRecordIds, Boolean usePreview, Boolean attachToRecord, List<Id> optionalDdpFileIds) {

    }
    global void addAttachmentIds(List<Id> attachmentIds) {

    }
global enum ThemeStyle {BOOTSTRAP_3_2, DRAWLOOP, NONE}
}
