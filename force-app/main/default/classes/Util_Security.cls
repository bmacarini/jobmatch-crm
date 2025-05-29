public with sharing class Util_Security {
    
    public static void checkReadAccess(String objectName) {
        if (!Schema.getGlobalDescribe().get(objectName).getDescribe().isAccessible()) {
            throw new System.NoAccessException('No read access for object: ' + objectName);
        }
    }

    public static void checkCreateAccess(String objectName) {
        if (!Schema.getGlobalDescribe().get(objectName).getDescribe().isCreateable()) {
            throw new System.NoAccessException('No create access for object: ' + objectName);
        }
    }

    public static void checkUpdateAccess(String objectName) {
        if (!Schema.getGlobalDescribe().get(objectName).getDescribe().isUpdateable()) {
            throw new System.NoAccessException('No update access for object: ' + objectName);
        }
    }

    public static void checkDeleteAccess(String objectName) {
        if (!Schema.getGlobalDescribe().get(objectName).getDescribe().isDeletable()) {
            throw new System.NoAccessException('No delete access for object: ' + objectName);
        }
    }

    public static void checkFieldAccess(String objectName, String fieldName) {
        Schema.DescribeFieldResult field = Schema.getGlobalDescribe()
            .get(objectName)
            .getDescribe()
            .fields.getMap()
            .get(fieldName)
            .getDescribe();

        if (!field.isAccessible()) {
            throw new System.NoAccessException('No read access for field: ' + fieldName);
        }
    }
}