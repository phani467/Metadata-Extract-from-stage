/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class loopMessage {
    global Loop.loopMessage.Notification batchNotification {
        get;
        set;
    }
    global String instance {
        get;
        set;
    }
    global List<Loop.loopMessage.loopMessageRequest> requests {
        get;
        set;
    }
    global String sessionId {
        get;
        set;
    }
    global Boolean usePreview {
        get;
        set;
    }
    global loopMessage() {

    }
    global static String send(String recordId, String ddpId, String variables, String instance) {
        return null;
    }
    global static void send(String recordId, String ddpId, String variables) {

    }
    global String sendAllRequests() {
        return null;
    }
    global static void send(String recordId, String ddpId, Map<String,String> variables) {

    }
    global static void send(String recordId, String ddpId, Map<String,String> variables, String instance) {

    }
global enum Notification {BEGIN_AND_COMPLETE, NONE, ON_COMPLETE, ON_ERROR}
global class loopMessageRequest {
    global List<Loop.AdHoc.Attachment> attachments {
        get;
        set;
    }
    global String ddpId {
        get;
        set;
    }
    global String recordId {
        get;
        set;
    }
    global Map<String,String> variables {
        get;
        set;
    }
    global loopMessageRequest(String recordId, String ddpId, Map<String,String> variables) {

    }
}
}
