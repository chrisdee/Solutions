function ULS8GF(){var o=new Object;o.ULSTeamName="Microsoft SharePoint Solutions Framework";o.ULSFileName="SP.WorkflowServices.debug.js";return o;}
// JScript File


Type.registerNamespace('SP.WorkflowServices');

SP.WorkflowServices.WorkflowStatus = function() {}
SP.WorkflowServices.WorkflowStatus.prototype = {
    notStarted: 0, 
    started: 1, 
    suspended: 2, 
    canceling: 3, 
    canceled: 4, 
    terminated: 5, 
    completed: 6, 
    notSpecified: 7, 
    invalid: 8
}
SP.WorkflowServices.WorkflowStatus.registerEnum('SP.WorkflowServices.WorkflowStatus', false);


SP.WorkflowServices.InteropService = function SP_WorkflowServices_InteropService(context, objectPath) {ULS8GF:;
    SP.WorkflowServices.InteropService.initializeBase(this, [ context, objectPath ]);
}
SP.WorkflowServices.InteropService.getCurrent = function SP_WorkflowServices_InteropService$getCurrent(Context) {ULS8GF:;
    var $v_0 = Context.get_staticObjects()['Microsoft$SharePoint$WorkflowServices$WorkflowInteropService$Current'];
    if ((!$v_0)) {
        $v_0 = new SP.WorkflowServices.InteropService(Context, new SP.ObjectPathStaticProperty(Context, '{aeda1ae7-a445-429d-ad92-1d6b00df7102}', 'Current'));
        Context.get_staticObjects()['Microsoft$SharePoint$WorkflowServices$WorkflowInteropService$Current'] = $v_0;
    }
    return ($v_0);
}
SP.WorkflowServices.InteropService.prototype = {
    
    enableEvents: function SP_WorkflowServices_InteropService$enableEvents(listId, itemGuid) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'EnableEvents', [ listId, itemGuid ]);
        $v_0.addQuery($v_1);
    },
    
    disableEvents: function SP_WorkflowServices_InteropService$disableEvents(listId, itemGuid) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'DisableEvents', [ listId, itemGuid ]);
        $v_0.addQuery($v_1);
    },
    
    startWorkflow: function SP_WorkflowServices_InteropService$startWorkflow(associationName, correlationId, listId, itemGuid, workflowParameters) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'StartWorkflow', [ associationName, correlationId, listId, itemGuid, workflowParameters ]);
        $v_0.addQuery($v_2);
        $v_1 = new SP.GuidResult();
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    },
    
    cancelWorkflow: function SP_WorkflowServices_InteropService$cancelWorkflow(instanceId) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'CancelWorkflow', [ instanceId ]);
        $v_0.addQuery($v_1);
    }
}


SP.WorkflowServices.WorkflowDefinition = function SP_WorkflowServices_WorkflowDefinition(context) {ULS8GF:;
    SP.WorkflowServices.WorkflowDefinition.initializeBase(this, [ context, SP.ClientUtility.getOrCreateObjectPathForConstructor(context, '{60320d36-4b4d-4bac-a092-8f8b5610edcd}', arguments) ]);
}
SP.WorkflowServices.WorkflowDefinition.newObject = function SP_WorkflowServices_WorkflowDefinition$newObject(context) {ULS8GF:;
    return new SP.WorkflowServices.WorkflowDefinition(context, new SP.ObjectPathConstructor(context, '{60320d36-4b4d-4bac-a092-8f8b5610edcd}', null));
}
SP.WorkflowServices.WorkflowDefinition.prototype = {
    
    get_associationUrl: function SP_WorkflowServices_WorkflowDefinition$get_associationUrl() {ULS8GF:;
        this.checkUninitializedProperty('AssociationUrl');
        return ((this.get_objectData().get_properties()['AssociationUrl']));
    },
    set_associationUrl: function SP_WorkflowServices_WorkflowDefinition$set_associationUrl(value) {ULS8GF:;
        this.get_objectData().get_properties()['AssociationUrl'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'AssociationUrl', value));
        }
        return value;
    },
    
    get_description: function SP_WorkflowServices_WorkflowDefinition$get_description() {ULS8GF:;
        this.checkUninitializedProperty('Description');
        return ((this.get_objectData().get_properties()['Description']));
    },
    set_description: function SP_WorkflowServices_WorkflowDefinition$set_description(value) {ULS8GF:;
        this.get_objectData().get_properties()['Description'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'Description', value));
        }
        return value;
    },
    
    get_displayName: function SP_WorkflowServices_WorkflowDefinition$get_displayName() {ULS8GF:;
        this.checkUninitializedProperty('DisplayName');
        return ((this.get_objectData().get_properties()['DisplayName']));
    },
    set_displayName: function SP_WorkflowServices_WorkflowDefinition$set_displayName(value) {ULS8GF:;
        this.get_objectData().get_properties()['DisplayName'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'DisplayName', value));
        }
        return value;
    },
    
    get_draftVersion: function SP_WorkflowServices_WorkflowDefinition$get_draftVersion() {ULS8GF:;
        this.checkUninitializedProperty('DraftVersion');
        return ((this.get_objectData().get_properties()['DraftVersion']));
    },
    set_draftVersion: function SP_WorkflowServices_WorkflowDefinition$set_draftVersion(value) {ULS8GF:;
        this.get_objectData().get_properties()['DraftVersion'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'DraftVersion', value));
        }
        return value;
    },
    
    get_formField: function SP_WorkflowServices_WorkflowDefinition$get_formField() {ULS8GF:;
        this.checkUninitializedProperty('FormField');
        return ((this.get_objectData().get_properties()['FormField']));
    },
    set_formField: function SP_WorkflowServices_WorkflowDefinition$set_formField(value) {ULS8GF:;
        this.get_objectData().get_properties()['FormField'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'FormField', value));
        }
        return value;
    },
    
    get_id: function SP_WorkflowServices_WorkflowDefinition$get_id() {ULS8GF:;
        this.checkUninitializedProperty('Id');
        return ((this.get_objectData().get_properties()['Id']));
    },
    set_id: function SP_WorkflowServices_WorkflowDefinition$set_id(value) {ULS8GF:;
        this.get_objectData().get_properties()['Id'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'Id', value));
        }
        return value;
    },
    
    get_initiationUrl: function SP_WorkflowServices_WorkflowDefinition$get_initiationUrl() {ULS8GF:;
        this.checkUninitializedProperty('InitiationUrl');
        return ((this.get_objectData().get_properties()['InitiationUrl']));
    },
    set_initiationUrl: function SP_WorkflowServices_WorkflowDefinition$set_initiationUrl(value) {ULS8GF:;
        this.get_objectData().get_properties()['InitiationUrl'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'InitiationUrl', value));
        }
        return value;
    },
    
    get_properties: function SP_WorkflowServices_WorkflowDefinition$get_properties() {ULS8GF:;
        this.checkUninitializedProperty('Properties');
        return ((this.get_objectData().get_properties()['Properties']));
    },
    
    get_published: function SP_WorkflowServices_WorkflowDefinition$get_published() {ULS8GF:;
        this.checkUninitializedProperty('Published');
        return ((this.get_objectData().get_properties()['Published']));
    },
    
    get_requiresAssociationForm: function SP_WorkflowServices_WorkflowDefinition$get_requiresAssociationForm() {ULS8GF:;
        this.checkUninitializedProperty('RequiresAssociationForm');
        return ((this.get_objectData().get_properties()['RequiresAssociationForm']));
    },
    set_requiresAssociationForm: function SP_WorkflowServices_WorkflowDefinition$set_requiresAssociationForm(value) {ULS8GF:;
        this.get_objectData().get_properties()['RequiresAssociationForm'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'RequiresAssociationForm', value));
        }
        return value;
    },
    
    get_requiresInitiationForm: function SP_WorkflowServices_WorkflowDefinition$get_requiresInitiationForm() {ULS8GF:;
        this.checkUninitializedProperty('RequiresInitiationForm');
        return ((this.get_objectData().get_properties()['RequiresInitiationForm']));
    },
    set_requiresInitiationForm: function SP_WorkflowServices_WorkflowDefinition$set_requiresInitiationForm(value) {ULS8GF:;
        this.get_objectData().get_properties()['RequiresInitiationForm'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'RequiresInitiationForm', value));
        }
        return value;
    },
    
    get_restrictToScope: function SP_WorkflowServices_WorkflowDefinition$get_restrictToScope() {ULS8GF:;
        this.checkUninitializedProperty('RestrictToScope');
        return ((this.get_objectData().get_properties()['RestrictToScope']));
    },
    set_restrictToScope: function SP_WorkflowServices_WorkflowDefinition$set_restrictToScope(value) {ULS8GF:;
        this.get_objectData().get_properties()['RestrictToScope'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'RestrictToScope', value));
        }
        return value;
    },
    
    get_restrictToType: function SP_WorkflowServices_WorkflowDefinition$get_restrictToType() {ULS8GF:;
        this.checkUninitializedProperty('RestrictToType');
        return ((this.get_objectData().get_properties()['RestrictToType']));
    },
    set_restrictToType: function SP_WorkflowServices_WorkflowDefinition$set_restrictToType(value) {ULS8GF:;
        this.get_objectData().get_properties()['RestrictToType'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'RestrictToType', value));
        }
        return value;
    },
    
    get_xaml: function SP_WorkflowServices_WorkflowDefinition$get_xaml() {ULS8GF:;
        this.checkUninitializedProperty('Xaml');
        return ((this.get_objectData().get_properties()['Xaml']));
    },
    set_xaml: function SP_WorkflowServices_WorkflowDefinition$set_xaml(value) {ULS8GF:;
        this.get_objectData().get_properties()['Xaml'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'Xaml', value));
        }
        return value;
    },
    
    initPropertiesFromJson: function SP_WorkflowServices_WorkflowDefinition$initPropertiesFromJson(parentNode) {ULS8GF:;
        SP.ClientObject.prototype.initPropertiesFromJson.call(this, parentNode);
        var $v_0;
        $v_0 = parentNode.AssociationUrl;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['AssociationUrl'] = ($v_0);
            delete parentNode.AssociationUrl;
        }
        $v_0 = parentNode.Description;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['Description'] = ($v_0);
            delete parentNode.Description;
        }
        $v_0 = parentNode.DisplayName;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['DisplayName'] = ($v_0);
            delete parentNode.DisplayName;
        }
        $v_0 = parentNode.DraftVersion;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['DraftVersion'] = ($v_0);
            delete parentNode.DraftVersion;
        }
        $v_0 = parentNode.FormField;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['FormField'] = ($v_0);
            delete parentNode.FormField;
        }
        $v_0 = parentNode.Id;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['Id'] = ($v_0);
            delete parentNode.Id;
        }
        $v_0 = parentNode.InitiationUrl;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['InitiationUrl'] = ($v_0);
            delete parentNode.InitiationUrl;
        }
        $v_0 = parentNode.Properties;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['Properties'] = ((SP.DataConvert.fixupType(this.get_context(), $v_0)));
            delete parentNode.Properties;
        }
        $v_0 = parentNode.Published;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['Published'] = ($v_0);
            delete parentNode.Published;
        }
        $v_0 = parentNode.RequiresAssociationForm;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['RequiresAssociationForm'] = ($v_0);
            delete parentNode.RequiresAssociationForm;
        }
        $v_0 = parentNode.RequiresInitiationForm;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['RequiresInitiationForm'] = ($v_0);
            delete parentNode.RequiresInitiationForm;
        }
        $v_0 = parentNode.RestrictToScope;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['RestrictToScope'] = ($v_0);
            delete parentNode.RestrictToScope;
        }
        $v_0 = parentNode.RestrictToType;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['RestrictToType'] = ($v_0);
            delete parentNode.RestrictToType;
        }
        $v_0 = parentNode.Xaml;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['Xaml'] = ($v_0);
            delete parentNode.Xaml;
        }
    },
    
    setProperty: function SP_WorkflowServices_WorkflowDefinition$setProperty(propertyName, value) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'SetProperty', [ propertyName, value ]);
        $v_0.addQuery($v_1);
    }
}


SP.WorkflowServices.WorkflowDefinitionPropertyNames = function SP_WorkflowServices_WorkflowDefinitionPropertyNames() {
}


SP.WorkflowServices.WorkflowDefinitionCollection = function SP_WorkflowServices_WorkflowDefinitionCollection(context, objectPath) {ULS8GF:;
    SP.WorkflowServices.WorkflowDefinitionCollection.initializeBase(this, [ context, objectPath ]);
}
SP.WorkflowServices.WorkflowDefinitionCollection.prototype = {
    
    itemAt: function SP_WorkflowServices_WorkflowDefinitionCollection$itemAt(index) {ULS8GF:;
        return this.getItemAtIndex(index);
    },
    
    get_item: function SP_WorkflowServices_WorkflowDefinitionCollection$get_item(index) {ULS8GF:;
        return this.getItemAtIndex(index);
    },
    
    get_childItemType: function SP_WorkflowServices_WorkflowDefinitionCollection$get_childItemType() {ULS8GF:;
        return SP.WorkflowServices.WorkflowDefinition;
    }
}


SP.WorkflowServices.WorkflowDeploymentService = function SP_WorkflowServices_WorkflowDeploymentService(context, objectPath) {ULS8GF:;
    SP.WorkflowServices.WorkflowDeploymentService.initializeBase(this, [ context, objectPath ]);
}
SP.WorkflowServices.WorkflowDeploymentService.prototype = {
    
    getDesignerActions: function SP_WorkflowServices_WorkflowDeploymentService$getDesignerActions(web) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'GetDesignerActions', [ web ]);
        $v_0.addQuery($v_2);
        $v_1 = new SP.StringResult();
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    },
    
    getActivitySignatures: function SP_WorkflowServices_WorkflowDeploymentService$getActivitySignatures(lastChanged) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'GetActivitySignatures', [ lastChanged ]);
        $v_0.addQuery($v_2);
        $v_1 = new SP.ClientResult();
        $v_0.addQueryIdAndResultObject($v_2.get_id(), new SP.ClientDictionaryResultHandler($v_1));
        return $v_1;
    },
    
    saveDefinition: function SP_WorkflowServices_WorkflowDeploymentService$saveDefinition(definition) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'SaveDefinition', [ definition ]);
        $v_0.addQuery($v_2);
        $v_1 = new SP.GuidResult();
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    },
    
    validateActivity: function SP_WorkflowServices_WorkflowDeploymentService$validateActivity(activityXaml) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'ValidateActivity', [ activityXaml ]);
        $v_0.addQuery($v_2);
        $v_1 = new SP.StringResult();
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    },
    
    publishDefinition: function SP_WorkflowServices_WorkflowDeploymentService$publishDefinition(definitionId) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'PublishDefinition', [ definitionId ]);
        $v_0.addQuery($v_1);
    },
    
    deprecateDefinition: function SP_WorkflowServices_WorkflowDeploymentService$deprecateDefinition(definitionId) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'DeprecateDefinition', [ definitionId ]);
        $v_0.addQuery($v_1);
    },
    
    deleteDefinition: function SP_WorkflowServices_WorkflowDeploymentService$deleteDefinition(definitionId) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'DeleteDefinition', [ definitionId ]);
        $v_0.addQuery($v_1);
    },
    
    enumerateDefinitions: function SP_WorkflowServices_WorkflowDeploymentService$enumerateDefinitions(publishedOnly) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        $v_1 = new SP.WorkflowServices.WorkflowDefinitionCollection($v_0, new SP.ObjectPathMethod($v_0, this.get_path(), 'EnumerateDefinitions', [ publishedOnly ]));
        return $v_1;
    },
    
    getDefinition: function SP_WorkflowServices_WorkflowDeploymentService$getDefinition(definitionId) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        $v_1 = new SP.WorkflowServices.WorkflowDefinition($v_0, new SP.ObjectPathMethod($v_0, this.get_path(), 'GetDefinition', [ definitionId ]));
        return $v_1;
    },
    
    saveCollateral: function SP_WorkflowServices_WorkflowDeploymentService$saveCollateral(workflowDefinitionId, leafFileName, fileContent) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'SaveCollateral', [ workflowDefinitionId, leafFileName, fileContent ]);
        $v_0.addQuery($v_1);
    },
    
    deleteCollateral: function SP_WorkflowServices_WorkflowDeploymentService$deleteCollateral(workflowDefinitionId, leafFileName) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'DeleteCollateral', [ workflowDefinitionId, leafFileName ]);
        $v_0.addQuery($v_1);
    },
    
    getCollateralUri: function SP_WorkflowServices_WorkflowDeploymentService$getCollateralUri(workflowDefinitionId, leafFileName) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'GetCollateralUri', [ workflowDefinitionId, leafFileName ]);
        $v_0.addQuery($v_2);
        $v_1 = new SP.StringResult();
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    },
    
    packageDefinition: function SP_WorkflowServices_WorkflowDeploymentService$packageDefinition(definitionId, packageDefaultFilename, packageTitle, packageDescription) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'PackageDefinition', [ definitionId, packageDefaultFilename, packageTitle, packageDescription ]);
        $v_0.addQuery($v_2);
        $v_1 = new SP.StringResult();
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    }
}


SP.WorkflowServices.WorkflowInstance = function SP_WorkflowServices_WorkflowInstance(context, objectPath) {ULS8GF:;
    SP.WorkflowServices.WorkflowInstance.initializeBase(this, [ context, objectPath ]);
}
SP.WorkflowServices.WorkflowInstance.prototype = {
    
    get_faultInfo: function SP_WorkflowServices_WorkflowInstance$get_faultInfo() {ULS8GF:;
        this.checkUninitializedProperty('FaultInfo');
        return ((this.get_objectData().get_properties()['FaultInfo']));
    },
    
    get_id: function SP_WorkflowServices_WorkflowInstance$get_id() {ULS8GF:;
        this.checkUninitializedProperty('Id');
        return ((this.get_objectData().get_properties()['Id']));
    },
    
    get_instanceCreated: function SP_WorkflowServices_WorkflowInstance$get_instanceCreated() {ULS8GF:;
        this.checkUninitializedProperty('InstanceCreated');
        return ((this.get_objectData().get_properties()['InstanceCreated']));
    },
    
    get_lastUpdated: function SP_WorkflowServices_WorkflowInstance$get_lastUpdated() {ULS8GF:;
        this.checkUninitializedProperty('LastUpdated');
        return ((this.get_objectData().get_properties()['LastUpdated']));
    },
    
    get_properties: function SP_WorkflowServices_WorkflowInstance$get_properties() {ULS8GF:;
        this.checkUninitializedProperty('Properties');
        return ((this.get_objectData().get_properties()['Properties']));
    },
    
    get_status: function SP_WorkflowServices_WorkflowInstance$get_status() {ULS8GF:;
        this.checkUninitializedProperty('Status');
        return ((this.get_objectData().get_properties()['Status']));
    },
    
    get_userStatus: function SP_WorkflowServices_WorkflowInstance$get_userStatus() {ULS8GF:;
        this.checkUninitializedProperty('UserStatus');
        return ((this.get_objectData().get_properties()['UserStatus']));
    },
    set_userStatus: function SP_WorkflowServices_WorkflowInstance$set_userStatus(value) {ULS8GF:;
        this.get_objectData().get_properties()['UserStatus'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'UserStatus', value));
        }
        return value;
    },
    
    get_workflowSubscriptionId: function SP_WorkflowServices_WorkflowInstance$get_workflowSubscriptionId() {ULS8GF:;
        this.checkUninitializedProperty('WorkflowSubscriptionId');
        return ((this.get_objectData().get_properties()['WorkflowSubscriptionId']));
    },
    
    initPropertiesFromJson: function SP_WorkflowServices_WorkflowInstance$initPropertiesFromJson(parentNode) {ULS8GF:;
        SP.ClientObject.prototype.initPropertiesFromJson.call(this, parentNode);
        var $v_0;
        $v_0 = parentNode.FaultInfo;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['FaultInfo'] = ($v_0);
            delete parentNode.FaultInfo;
        }
        $v_0 = parentNode.Id;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['Id'] = ($v_0);
            delete parentNode.Id;
        }
        $v_0 = parentNode.InstanceCreated;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['InstanceCreated'] = ($v_0);
            delete parentNode.InstanceCreated;
        }
        $v_0 = parentNode.LastUpdated;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['LastUpdated'] = ($v_0);
            delete parentNode.LastUpdated;
        }
        $v_0 = parentNode.Properties;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['Properties'] = ((SP.DataConvert.fixupType(this.get_context(), $v_0)));
            delete parentNode.Properties;
        }
        $v_0 = parentNode.Status;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['Status'] = ((SP.DataConvert.fixupType(this.get_context(), $v_0)));
            delete parentNode.Status;
        }
        $v_0 = parentNode.UserStatus;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['UserStatus'] = ($v_0);
            delete parentNode.UserStatus;
        }
        $v_0 = parentNode.WorkflowSubscriptionId;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['WorkflowSubscriptionId'] = ($v_0);
            delete parentNode.WorkflowSubscriptionId;
        }
    }
}


SP.WorkflowServices.WorkflowInstancePropertyNames = function SP_WorkflowServices_WorkflowInstancePropertyNames() {
}


SP.WorkflowServices.WorkflowInstanceCollection = function SP_WorkflowServices_WorkflowInstanceCollection(context, objectPath) {ULS8GF:;
    SP.WorkflowServices.WorkflowInstanceCollection.initializeBase(this, [ context, objectPath ]);
}
SP.WorkflowServices.WorkflowInstanceCollection.prototype = {
    
    itemAt: function SP_WorkflowServices_WorkflowInstanceCollection$itemAt(index) {ULS8GF:;
        return this.getItemAtIndex(index);
    },
    
    get_item: function SP_WorkflowServices_WorkflowInstanceCollection$get_item(index) {ULS8GF:;
        return this.getItemAtIndex(index);
    },
    
    get_childItemType: function SP_WorkflowServices_WorkflowInstanceCollection$get_childItemType() {ULS8GF:;
        return SP.WorkflowServices.WorkflowInstance;
    }
}


SP.WorkflowServices.WorkflowInstanceService = function SP_WorkflowServices_WorkflowInstanceService(context, objectPath) {ULS8GF:;
    SP.WorkflowServices.WorkflowInstanceService.initializeBase(this, [ context, objectPath ]);
}
SP.WorkflowServices.WorkflowInstanceService.getCurrent = function SP_WorkflowServices_WorkflowInstanceService$getCurrent(Context) {ULS8GF:;
    var $v_0 = Context.get_staticObjects()['Microsoft$SharePoint$WorkflowServices$WorkflowInstanceService$Current'];
    if ((!$v_0)) {
        $v_0 = new SP.WorkflowServices.WorkflowInstanceService(Context, new SP.ObjectPathStaticProperty(Context, '{71252277-2470-4022-bcaf-c4657aa118c3}', 'Current'));
        Context.get_staticObjects()['Microsoft$SharePoint$WorkflowServices$WorkflowInstanceService$Current'] = $v_0;
    }
    return ($v_0);
}
SP.WorkflowServices.WorkflowInstanceService.prototype = {
    
    startWorkflow: function SP_WorkflowServices_WorkflowInstanceService$startWorkflow(subscription, payload) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'StartWorkflow', [ subscription, payload ]);
        $v_0.addQuery($v_2);
        $v_1 = new SP.GuidResult();
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    },
    
    startWorkflowOnListItem: function SP_WorkflowServices_WorkflowInstanceService$startWorkflowOnListItem(subscription, itemId, payload) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'StartWorkflowOnListItem', [ subscription, itemId, payload ]);
        $v_0.addQuery($v_2);
        $v_1 = new SP.GuidResult();
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    },
    
    getInstance: function SP_WorkflowServices_WorkflowInstanceService$getInstance(instanceId) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        $v_1 = new SP.WorkflowServices.WorkflowInstance($v_0, new SP.ObjectPathMethod($v_0, this.get_path(), 'GetInstance', [ instanceId ]));
        return $v_1;
    },
    
    enumerate: function SP_WorkflowServices_WorkflowInstanceService$enumerate(parentSubscription) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        $v_1 = new SP.WorkflowServices.WorkflowInstanceCollection($v_0, new SP.ObjectPathMethod($v_0, this.get_path(), 'Enumerate', [ parentSubscription ]));
        return $v_1;
    },
    
    enumerateWithOffset: function SP_WorkflowServices_WorkflowInstanceService$enumerateWithOffset(parentSubscription, offset) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        $v_1 = new SP.WorkflowServices.WorkflowInstanceCollection($v_0, new SP.ObjectPathMethod($v_0, this.get_path(), 'EnumerateWithOffset', [ parentSubscription, offset ]));
        return $v_1;
    },
    
    enumerateInstancesForListItem: function SP_WorkflowServices_WorkflowInstanceService$enumerateInstancesForListItem(listId, itemId) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        $v_1 = new SP.WorkflowServices.WorkflowInstanceCollection($v_0, new SP.ObjectPathMethod($v_0, this.get_path(), 'EnumerateInstancesForListItem', [ listId, itemId ]));
        return $v_1;
    },
    
    enumerateInstancesForListItemWithOffset: function SP_WorkflowServices_WorkflowInstanceService$enumerateInstancesForListItemWithOffset(listId, itemId, offset) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        $v_1 = new SP.WorkflowServices.WorkflowInstanceCollection($v_0, new SP.ObjectPathMethod($v_0, this.get_path(), 'EnumerateInstancesForListItemWithOffset', [ listId, itemId, offset ]));
        return $v_1;
    },
    
    enumerateInstancesForSite: function SP_WorkflowServices_WorkflowInstanceService$enumerateInstancesForSite() {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        $v_1 = new SP.WorkflowServices.WorkflowInstanceCollection($v_0, new SP.ObjectPathMethod($v_0, this.get_path(), 'EnumerateInstancesForSite', null));
        return $v_1;
    },
    
    enumerateInstancesForSiteWithOffset: function SP_WorkflowServices_WorkflowInstanceService$enumerateInstancesForSiteWithOffset(offset) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        $v_1 = new SP.WorkflowServices.WorkflowInstanceCollection($v_0, new SP.ObjectPathMethod($v_0, this.get_path(), 'EnumerateInstancesForSiteWithOffset', [ offset ]));
        return $v_1;
    },
    
    countInstances: function SP_WorkflowServices_WorkflowInstanceService$countInstances(parentSubscription) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'CountInstances', [ parentSubscription ]);
        $v_0.addQuery($v_2);
        $v_1 = new SP.IntResult();
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    },
    
    countInstancesWithStatus: function SP_WorkflowServices_WorkflowInstanceService$countInstancesWithStatus(parentSubscription, status) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'CountInstancesWithStatus', [ parentSubscription, status ]);
        $v_0.addQuery($v_2);
        $v_1 = new SP.IntResult();
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    },
    
    cancelWorkflow: function SP_WorkflowServices_WorkflowInstanceService$cancelWorkflow(instance) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'CancelWorkflow', [ instance ]);
        $v_0.addQuery($v_1);
    },
    
    terminateWorkflow: function SP_WorkflowServices_WorkflowInstanceService$terminateWorkflow(instance) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'TerminateWorkflow', [ instance ]);
        $v_0.addQuery($v_1);
    },
    
    suspendWorkflow: function SP_WorkflowServices_WorkflowInstanceService$suspendWorkflow(instance) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'SuspendWorkflow', [ instance ]);
        $v_0.addQuery($v_1);
    },
    
    resumeWorkflow: function SP_WorkflowServices_WorkflowInstanceService$resumeWorkflow(instance) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'ResumeWorkflow', [ instance ]);
        $v_0.addQuery($v_1);
    },
    
    publishCustomEvent: function SP_WorkflowServices_WorkflowInstanceService$publishCustomEvent(instance, eventName, payload) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'PublishCustomEvent', [ instance, eventName, payload ]);
        $v_0.addQuery($v_1);
    },
    
    getDebugInfo: function SP_WorkflowServices_WorkflowInstanceService$getDebugInfo(instance) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'GetDebugInfo', [ instance ]);
        $v_0.addQuery($v_2);
        $v_1 = new SP.StringResult();
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    }
}


SP.WorkflowServices.WorkflowServicesManager = function SP_WorkflowServices_WorkflowServicesManager(context, web) {ULS8GF:;
    SP.WorkflowServices.WorkflowServicesManager.initializeBase(this, [ context, SP.ClientUtility.getOrCreateObjectPathForConstructor(context, '{4ccc7f0e-bf7e-4477-999c-6458a73d0039}', arguments) ]);
}
SP.WorkflowServices.WorkflowServicesManager.newObject = function SP_WorkflowServices_WorkflowServicesManager$newObject(context, web) {ULS8GF:;
    return new SP.WorkflowServices.WorkflowServicesManager(context, new SP.ObjectPathConstructor(context, '{4ccc7f0e-bf7e-4477-999c-6458a73d0039}', [ web ]));
}
SP.WorkflowServices.WorkflowServicesManager.prototype = {
    
    get_appId: function SP_WorkflowServices_WorkflowServicesManager$get_appId() {ULS8GF:;
        this.checkUninitializedProperty('AppId');
        return ((this.get_objectData().get_properties()['AppId']));
    },
    
    get_isConnected: function SP_WorkflowServices_WorkflowServicesManager$get_isConnected() {ULS8GF:;
        this.checkUninitializedProperty('IsConnected');
        return ((this.get_objectData().get_properties()['IsConnected']));
    },
    
    get_scopePath: function SP_WorkflowServices_WorkflowServicesManager$get_scopePath() {ULS8GF:;
        this.checkUninitializedProperty('ScopePath');
        return ((this.get_objectData().get_properties()['ScopePath']));
    },
    
    initPropertiesFromJson: function SP_WorkflowServices_WorkflowServicesManager$initPropertiesFromJson(parentNode) {ULS8GF:;
        SP.ClientObject.prototype.initPropertiesFromJson.call(this, parentNode);
        var $v_0;
        $v_0 = parentNode.AppId;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['AppId'] = ($v_0);
            delete parentNode.AppId;
        }
        $v_0 = parentNode.IsConnected;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['IsConnected'] = ($v_0);
            delete parentNode.IsConnected;
        }
        $v_0 = parentNode.ScopePath;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['ScopePath'] = ($v_0);
            delete parentNode.ScopePath;
        }
    },
    
    getWorkflowDeploymentService: function SP_WorkflowServices_WorkflowServicesManager$getWorkflowDeploymentService() {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        $v_1 = new SP.WorkflowServices.WorkflowDeploymentService($v_0, new SP.ObjectPathMethod($v_0, this.get_path(), 'GetWorkflowDeploymentService', null));
        return $v_1;
    },
    
    getWorkflowInstanceService: function SP_WorkflowServices_WorkflowServicesManager$getWorkflowInstanceService() {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        $v_1 = new SP.WorkflowServices.WorkflowInstanceService($v_0, new SP.ObjectPathMethod($v_0, this.get_path(), 'GetWorkflowInstanceService', null));
        return $v_1;
    },
    
    getWorkflowInteropService: function SP_WorkflowServices_WorkflowServicesManager$getWorkflowInteropService() {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        $v_1 = new SP.WorkflowServices.InteropService($v_0, new SP.ObjectPathMethod($v_0, this.get_path(), 'GetWorkflowInteropService', null));
        return $v_1;
    },
    
    getWorkflowSubscriptionService: function SP_WorkflowServices_WorkflowServicesManager$getWorkflowSubscriptionService() {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        $v_1 = new SP.WorkflowServices.WorkflowSubscriptionService($v_0, new SP.ObjectPathMethod($v_0, this.get_path(), 'GetWorkflowSubscriptionService', null));
        return $v_1;
    }
}


SP.WorkflowServices.WorkflowServicesManagerPropertyNames = function SP_WorkflowServices_WorkflowServicesManagerPropertyNames() {
}


SP.WorkflowServices.WorkflowSubscription = function SP_WorkflowServices_WorkflowSubscription(context) {ULS8GF:;
    SP.WorkflowServices.WorkflowSubscription.initializeBase(this, [ context, SP.ClientUtility.getOrCreateObjectPathForConstructor(context, '{d185ede6-c3c3-4d37-9e8c-2382deb37708}', arguments) ]);
}
SP.WorkflowServices.WorkflowSubscription.newObject = function SP_WorkflowServices_WorkflowSubscription$newObject(context) {ULS8GF:;
    return new SP.WorkflowServices.WorkflowSubscription(context, new SP.ObjectPathConstructor(context, '{d185ede6-c3c3-4d37-9e8c-2382deb37708}', null));
}
SP.WorkflowServices.WorkflowSubscription.prototype = {
    
    get_definitionId: function SP_WorkflowServices_WorkflowSubscription$get_definitionId() {ULS8GF:;
        this.checkUninitializedProperty('DefinitionId');
        return ((this.get_objectData().get_properties()['DefinitionId']));
    },
    set_definitionId: function SP_WorkflowServices_WorkflowSubscription$set_definitionId(value) {ULS8GF:;
        this.get_objectData().get_properties()['DefinitionId'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'DefinitionId', value));
        }
        return value;
    },
    
    get_enabled: function SP_WorkflowServices_WorkflowSubscription$get_enabled() {ULS8GF:;
        this.checkUninitializedProperty('Enabled');
        return ((this.get_objectData().get_properties()['Enabled']));
    },
    set_enabled: function SP_WorkflowServices_WorkflowSubscription$set_enabled(value) {ULS8GF:;
        this.get_objectData().get_properties()['Enabled'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'Enabled', value));
        }
        return value;
    },
    
    get_eventSourceId: function SP_WorkflowServices_WorkflowSubscription$get_eventSourceId() {ULS8GF:;
        this.checkUninitializedProperty('EventSourceId');
        return ((this.get_objectData().get_properties()['EventSourceId']));
    },
    set_eventSourceId: function SP_WorkflowServices_WorkflowSubscription$set_eventSourceId(value) {ULS8GF:;
        this.get_objectData().get_properties()['EventSourceId'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'EventSourceId', value));
        }
        return value;
    },
    
    get_eventTypes: function SP_WorkflowServices_WorkflowSubscription$get_eventTypes() {ULS8GF:;
        this.checkUninitializedProperty('EventTypes');
        return ((this.get_objectData().get_properties()['EventTypes']));
    },
    set_eventTypes: function SP_WorkflowServices_WorkflowSubscription$set_eventTypes(value) {ULS8GF:;
        this.get_objectData().get_properties()['EventTypes'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'EventTypes', value));
        }
        return value;
    },
    
    get_id: function SP_WorkflowServices_WorkflowSubscription$get_id() {ULS8GF:;
        this.checkUninitializedProperty('Id');
        return ((this.get_objectData().get_properties()['Id']));
    },
    set_id: function SP_WorkflowServices_WorkflowSubscription$set_id(value) {ULS8GF:;
        this.get_objectData().get_properties()['Id'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'Id', value));
        }
        return value;
    },
    
    get_manualStartBypassesActivationLimit: function SP_WorkflowServices_WorkflowSubscription$get_manualStartBypassesActivationLimit() {ULS8GF:;
        this.checkUninitializedProperty('ManualStartBypassesActivationLimit');
        return ((this.get_objectData().get_properties()['ManualStartBypassesActivationLimit']));
    },
    set_manualStartBypassesActivationLimit: function SP_WorkflowServices_WorkflowSubscription$set_manualStartBypassesActivationLimit(value) {ULS8GF:;
        this.get_objectData().get_properties()['ManualStartBypassesActivationLimit'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'ManualStartBypassesActivationLimit', value));
        }
        return value;
    },
    
    get_name: function SP_WorkflowServices_WorkflowSubscription$get_name() {ULS8GF:;
        this.checkUninitializedProperty('Name');
        return ((this.get_objectData().get_properties()['Name']));
    },
    set_name: function SP_WorkflowServices_WorkflowSubscription$set_name(value) {ULS8GF:;
        this.get_objectData().get_properties()['Name'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'Name', value));
        }
        return value;
    },
    
    get_propertyDefinitions: function SP_WorkflowServices_WorkflowSubscription$get_propertyDefinitions() {ULS8GF:;
        this.checkUninitializedProperty('PropertyDefinitions');
        return ((this.get_objectData().get_properties()['PropertyDefinitions']));
    },
    
    get_statusFieldName: function SP_WorkflowServices_WorkflowSubscription$get_statusFieldName() {ULS8GF:;
        this.checkUninitializedProperty('StatusFieldName');
        return ((this.get_objectData().get_properties()['StatusFieldName']));
    },
    set_statusFieldName: function SP_WorkflowServices_WorkflowSubscription$set_statusFieldName(value) {ULS8GF:;
        this.get_objectData().get_properties()['StatusFieldName'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'StatusFieldName', value));
        }
        return value;
    },
    
    initPropertiesFromJson: function SP_WorkflowServices_WorkflowSubscription$initPropertiesFromJson(parentNode) {ULS8GF:;
        SP.ClientObject.prototype.initPropertiesFromJson.call(this, parentNode);
        var $v_0;
        $v_0 = parentNode.DefinitionId;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['DefinitionId'] = ($v_0);
            delete parentNode.DefinitionId;
        }
        $v_0 = parentNode.Enabled;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['Enabled'] = ($v_0);
            delete parentNode.Enabled;
        }
        $v_0 = parentNode.EventSourceId;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['EventSourceId'] = ($v_0);
            delete parentNode.EventSourceId;
        }
        $v_0 = parentNode.EventTypes;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['EventTypes'] = ((SP.DataConvert.fixupType(this.get_context(), $v_0)));
            delete parentNode.EventTypes;
        }
        $v_0 = parentNode.Id;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['Id'] = ($v_0);
            delete parentNode.Id;
        }
        $v_0 = parentNode.ManualStartBypassesActivationLimit;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['ManualStartBypassesActivationLimit'] = ($v_0);
            delete parentNode.ManualStartBypassesActivationLimit;
        }
        $v_0 = parentNode.Name;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['Name'] = ($v_0);
            delete parentNode.Name;
        }
        $v_0 = parentNode.PropertyDefinitions;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['PropertyDefinitions'] = ((SP.DataConvert.fixupType(this.get_context(), $v_0)));
            delete parentNode.PropertyDefinitions;
        }
        $v_0 = parentNode.StatusFieldName;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['StatusFieldName'] = ($v_0);
            delete parentNode.StatusFieldName;
        }
    },
    
    setProperty: function SP_WorkflowServices_WorkflowSubscription$setProperty(name, value) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'SetProperty', [ name, value ]);
        $v_0.addQuery($v_1);
    },
    
    setExternalVariable: function SP_WorkflowServices_WorkflowSubscription$setExternalVariable(name, value) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'SetExternalVariable', [ name, value ]);
        $v_0.addQuery($v_1);
    },
    
    getExternalVariable: function SP_WorkflowServices_WorkflowSubscription$getExternalVariable(name) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'GetExternalVariable', [ name ]);
        $v_0.addQuery($v_2);
        $v_1 = new SP.StringResult();
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    }
}


SP.WorkflowServices.WorkflowSubscriptionPropertyNames = function SP_WorkflowServices_WorkflowSubscriptionPropertyNames() {
}


SP.WorkflowServices.WorkflowSubscriptionCollection = function SP_WorkflowServices_WorkflowSubscriptionCollection(context, objectPath) {ULS8GF:;
    SP.WorkflowServices.WorkflowSubscriptionCollection.initializeBase(this, [ context, objectPath ]);
}
SP.WorkflowServices.WorkflowSubscriptionCollection.prototype = {
    
    itemAt: function SP_WorkflowServices_WorkflowSubscriptionCollection$itemAt(index) {ULS8GF:;
        return this.getItemAtIndex(index);
    },
    
    get_item: function SP_WorkflowServices_WorkflowSubscriptionCollection$get_item(index) {ULS8GF:;
        return this.getItemAtIndex(index);
    },
    
    get_childItemType: function SP_WorkflowServices_WorkflowSubscriptionCollection$get_childItemType() {ULS8GF:;
        return SP.WorkflowServices.WorkflowSubscription;
    }
}


SP.WorkflowServices.WorkflowSubscriptionService = function SP_WorkflowServices_WorkflowSubscriptionService(context, objectPath) {ULS8GF:;
    SP.WorkflowServices.WorkflowSubscriptionService.initializeBase(this, [ context, objectPath ]);
}
SP.WorkflowServices.WorkflowSubscriptionService.getCurrent = function SP_WorkflowServices_WorkflowSubscriptionService$getCurrent(Context) {ULS8GF:;
    var $v_0 = Context.get_staticObjects()['Microsoft$SharePoint$WorkflowServices$WorkflowSubscriptionService$Current'];
    if ((!$v_0)) {
        $v_0 = new SP.WorkflowServices.WorkflowSubscriptionService(Context, new SP.ObjectPathStaticProperty(Context, '{fc956693-2419-4950-8963-52ebc3e46501}', 'Current'));
        Context.get_staticObjects()['Microsoft$SharePoint$WorkflowServices$WorkflowSubscriptionService$Current'] = $v_0;
    }
    return ($v_0);
}
SP.WorkflowServices.WorkflowSubscriptionService.prototype = {
    
    publishSubscription: function SP_WorkflowServices_WorkflowSubscriptionService$publishSubscription(subscription) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'PublishSubscription', [ subscription ]);
        $v_0.addQuery($v_2);
        $v_1 = new SP.GuidResult();
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    },
    
    publishSubscriptionForList: function SP_WorkflowServices_WorkflowSubscriptionService$publishSubscriptionForList(subscription, listId) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'PublishSubscriptionForList', [ subscription, listId ]);
        $v_0.addQuery($v_2);
        $v_1 = new SP.GuidResult();
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    },
    
    registerInterestInList: function SP_WorkflowServices_WorkflowSubscriptionService$registerInterestInList(listId, eventName) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'RegisterInterestInList', [ listId, eventName ]);
        $v_0.addQuery($v_1);
    },
    
    unregisterInterestInList: function SP_WorkflowServices_WorkflowSubscriptionService$unregisterInterestInList(listId, eventName) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'UnregisterInterestInList', [ listId, eventName ]);
        $v_0.addQuery($v_1);
    },
    
    getSubscription: function SP_WorkflowServices_WorkflowSubscriptionService$getSubscription(subscriptionId) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        $v_1 = new SP.WorkflowServices.WorkflowSubscription($v_0, new SP.ObjectPathMethod($v_0, this.get_path(), 'GetSubscription', [ subscriptionId ]));
        return $v_1;
    },
    
    deleteSubscription: function SP_WorkflowServices_WorkflowSubscriptionService$deleteSubscription(subscriptionId) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'DeleteSubscription', [ subscriptionId ]);
        $v_0.addQuery($v_1);
    },
    
    enumerateSubscriptions: function SP_WorkflowServices_WorkflowSubscriptionService$enumerateSubscriptions() {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        $v_1 = new SP.WorkflowServices.WorkflowSubscriptionCollection($v_0, new SP.ObjectPathMethod($v_0, this.get_path(), 'EnumerateSubscriptions', null));
        return $v_1;
    },
    
    enumerateSubscriptionsByDefinition: function SP_WorkflowServices_WorkflowSubscriptionService$enumerateSubscriptionsByDefinition(definitionId) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        $v_1 = new SP.WorkflowServices.WorkflowSubscriptionCollection($v_0, new SP.ObjectPathMethod($v_0, this.get_path(), 'EnumerateSubscriptionsByDefinition', [ definitionId ]));
        return $v_1;
    },
    
    enumerateSubscriptionsByEventSource: function SP_WorkflowServices_WorkflowSubscriptionService$enumerateSubscriptionsByEventSource(eventSourceId) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        $v_1 = new SP.WorkflowServices.WorkflowSubscriptionCollection($v_0, new SP.ObjectPathMethod($v_0, this.get_path(), 'EnumerateSubscriptionsByEventSource', [ eventSourceId ]));
        return $v_1;
    },
    
    enumerateSubscriptionsByList: function SP_WorkflowServices_WorkflowSubscriptionService$enumerateSubscriptionsByList(listId) {ULS8GF:;
        var $v_0 = this.get_context();
        var $v_1;
        $v_1 = new SP.WorkflowServices.WorkflowSubscriptionCollection($v_0, new SP.ObjectPathMethod($v_0, this.get_path(), 'EnumerateSubscriptionsByList', [ listId ]));
        return $v_1;
    }
}


SP.WorkflowServices.InteropService.registerClass('SP.WorkflowServices.InteropService', SP.ClientObject);
SP.WorkflowServices.WorkflowDefinition.registerClass('SP.WorkflowServices.WorkflowDefinition', SP.ClientObject);
SP.WorkflowServices.WorkflowDefinitionPropertyNames.registerClass('SP.WorkflowServices.WorkflowDefinitionPropertyNames');
SP.WorkflowServices.WorkflowDefinitionCollection.registerClass('SP.WorkflowServices.WorkflowDefinitionCollection', SP.ClientObjectCollection);
SP.WorkflowServices.WorkflowDeploymentService.registerClass('SP.WorkflowServices.WorkflowDeploymentService', SP.ClientObject);
SP.WorkflowServices.WorkflowInstance.registerClass('SP.WorkflowServices.WorkflowInstance', SP.ClientObject);
SP.WorkflowServices.WorkflowInstancePropertyNames.registerClass('SP.WorkflowServices.WorkflowInstancePropertyNames');
SP.WorkflowServices.WorkflowInstanceCollection.registerClass('SP.WorkflowServices.WorkflowInstanceCollection', SP.ClientObjectCollection);
SP.WorkflowServices.WorkflowInstanceService.registerClass('SP.WorkflowServices.WorkflowInstanceService', SP.ClientObject);
SP.WorkflowServices.WorkflowServicesManager.registerClass('SP.WorkflowServices.WorkflowServicesManager', SP.ClientObject);
SP.WorkflowServices.WorkflowServicesManagerPropertyNames.registerClass('SP.WorkflowServices.WorkflowServicesManagerPropertyNames');
SP.WorkflowServices.WorkflowSubscription.registerClass('SP.WorkflowServices.WorkflowSubscription', SP.ClientObject);
SP.WorkflowServices.WorkflowSubscriptionPropertyNames.registerClass('SP.WorkflowServices.WorkflowSubscriptionPropertyNames');
SP.WorkflowServices.WorkflowSubscriptionCollection.registerClass('SP.WorkflowServices.WorkflowSubscriptionCollection', SP.ClientObjectCollection);
SP.WorkflowServices.WorkflowSubscriptionService.registerClass('SP.WorkflowServices.WorkflowSubscriptionService', SP.ClientObject);
SP.WorkflowServices.WorkflowDefinitionPropertyNames.associationUrl = 'AssociationUrl';
SP.WorkflowServices.WorkflowDefinitionPropertyNames.description = 'Description';
SP.WorkflowServices.WorkflowDefinitionPropertyNames.displayName = 'DisplayName';
SP.WorkflowServices.WorkflowDefinitionPropertyNames.draftVersion = 'DraftVersion';
SP.WorkflowServices.WorkflowDefinitionPropertyNames.formField = 'FormField';
SP.WorkflowServices.WorkflowDefinitionPropertyNames.id = 'Id';
SP.WorkflowServices.WorkflowDefinitionPropertyNames.initiationUrl = 'InitiationUrl';
SP.WorkflowServices.WorkflowDefinitionPropertyNames.properties = 'Properties';
SP.WorkflowServices.WorkflowDefinitionPropertyNames.published = 'Published';
SP.WorkflowServices.WorkflowDefinitionPropertyNames.requiresAssociationForm = 'RequiresAssociationForm';
SP.WorkflowServices.WorkflowDefinitionPropertyNames.requiresInitiationForm = 'RequiresInitiationForm';
SP.WorkflowServices.WorkflowDefinitionPropertyNames.restrictToScope = 'RestrictToScope';
SP.WorkflowServices.WorkflowDefinitionPropertyNames.restrictToType = 'RestrictToType';
SP.WorkflowServices.WorkflowDefinitionPropertyNames.xaml = 'Xaml';
SP.WorkflowServices.WorkflowInstancePropertyNames.faultInfo = 'FaultInfo';
SP.WorkflowServices.WorkflowInstancePropertyNames.id = 'Id';
SP.WorkflowServices.WorkflowInstancePropertyNames.instanceCreated = 'InstanceCreated';
SP.WorkflowServices.WorkflowInstancePropertyNames.lastUpdated = 'LastUpdated';
SP.WorkflowServices.WorkflowInstancePropertyNames.properties = 'Properties';
SP.WorkflowServices.WorkflowInstancePropertyNames.status = 'Status';
SP.WorkflowServices.WorkflowInstancePropertyNames.userStatus = 'UserStatus';
SP.WorkflowServices.WorkflowInstancePropertyNames.workflowSubscriptionId = 'WorkflowSubscriptionId';
SP.WorkflowServices.WorkflowServicesManagerPropertyNames.appId = 'AppId';
SP.WorkflowServices.WorkflowServicesManagerPropertyNames.isConnected = 'IsConnected';
SP.WorkflowServices.WorkflowServicesManagerPropertyNames.scopePath = 'ScopePath';
SP.WorkflowServices.WorkflowSubscriptionPropertyNames.definitionId = 'DefinitionId';
SP.WorkflowServices.WorkflowSubscriptionPropertyNames.enabled = 'Enabled';
SP.WorkflowServices.WorkflowSubscriptionPropertyNames.eventSourceId = 'EventSourceId';
SP.WorkflowServices.WorkflowSubscriptionPropertyNames.eventTypes = 'EventTypes';
SP.WorkflowServices.WorkflowSubscriptionPropertyNames.id = 'Id';
SP.WorkflowServices.WorkflowSubscriptionPropertyNames.manualStartBypassesActivationLimit = 'ManualStartBypassesActivationLimit';
SP.WorkflowServices.WorkflowSubscriptionPropertyNames.name = 'Name';
SP.WorkflowServices.WorkflowSubscriptionPropertyNames.propertyDefinitions = 'PropertyDefinitions';
SP.WorkflowServices.WorkflowSubscriptionPropertyNames.statusFieldName = 'StatusFieldName';

if( typeof(Sys) != "undefined" && Sys && Sys.Application ){
   Sys.Application.notifyScriptLoaded();
}
NotifyScriptLoadedAndExecuteWaitingJobs("SP.WorkflowServices.js");
