/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global interface IApexDataSource {
    List<Loop.ExternalData.DataObject> describeObjects(List<String> param0);
    Set<String> getChildRelationships(String param0);
    Set<String> getGlobalDescribe();
    Loop.ExternalData.QueryResultSet query(Loop.ExternalData.QueryRequestInfo param0);
}
