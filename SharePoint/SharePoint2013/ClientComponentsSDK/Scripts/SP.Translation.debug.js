// JScript File


Type.registerNamespace('SP.Translation');

SP.Translation.ItemTypes = function() {}
SP.Translation.ItemTypes.prototype = {
    succeeded: 1, 
    inProgress: 2, 
    notStarted: 4, 
    failed: 8, 
    canceled: 16
}
SP.Translation.ItemTypes.registerEnum('SP.Translation.ItemTypes', false);


SP.Translation.SaveBehavior = function() {}
SP.Translation.SaveBehavior.prototype = {
    appendIfPossible: 0, 
    alwaysOverwrite: 1, 
    appendOnly: 2, 
    neverOverwrite: 3
}
SP.Translation.SaveBehavior.registerEnum('SP.Translation.SaveBehavior', false);


SP.Translation.TranslationResult = function() {}
SP.Translation.TranslationResult.prototype = {
    unknownFailure: -1, 
    succeeded: 0, 
    inputFileNotFound: 1, 
    unauthorizedAccessToInputFile: 2, 
    inputFileUserTokenExpired: 3, 
    unauthorizedAccessToOutputFile: 4, 
    outputFileUserTokenExpired: 5, 
    inputFileReadError: 6, 
    outputFileWriteError: 7, 
    notAssignedToWorker: 8, 
    workerFailed: 9, 
    timeout: 10, 
    syncTranslationLimitExceeded: 11, 
    syncTranslationDisabled: 12, 
    outputFileReadOnly: 13, 
    inputFileTooLarge: 14, 
    inputFileTooLong: 15, 
    inputFileCorrupt: 16, 
    inputFileIRMProtected: 17, 
    inputFileEncrypted: 18, 
    inputFileTypeBlocked: 19, 
    inputFileTypeNotSupported: 20, 
    inputFileHasActiveXControls: 21, 
    inputFileCannotBeTranslated: 22, 
    translationServiceUnavailable: 23
}
SP.Translation.TranslationResult.registerEnum('SP.Translation.TranslationResult', false);


SP.Translation.SyncTranslator = function SP_Translation_SyncTranslator(context, targetLanguage) {
    SP.Translation.SyncTranslator.initializeBase(this, [ context, SP.ClientUtility.getOrCreateObjectPathForConstructor(context, '{5286f36c-929c-49d8-bf42-39effc672aaf}', arguments) ]);
}
SP.Translation.SyncTranslator.newObject = function SP_Translation_SyncTranslator$newObject(context, targetLanguage) {
    return new SP.Translation.SyncTranslator(context, new SP.ObjectPathConstructor(context, '{5286f36c-929c-49d8-bf42-39effc672aaf}', [ targetLanguage ]));
}
SP.Translation.SyncTranslator.prototype = {
    
    get_outputSaveBehavior: function SP_Translation_SyncTranslator$get_outputSaveBehavior() {
        this.checkUninitializedProperty('OutputSaveBehavior');
        return ((this.get_objectData().get_properties()['OutputSaveBehavior']));
    },
    set_outputSaveBehavior: function SP_Translation_SyncTranslator$set_outputSaveBehavior(value) {
        this.get_objectData().get_properties()['OutputSaveBehavior'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'OutputSaveBehavior', value));
        }
        return value;
    },
    
    initPropertiesFromJson: function SP_Translation_SyncTranslator$initPropertiesFromJson(parentNode) {
        SP.ClientObject.prototype.initPropertiesFromJson.call(this, parentNode);
        var $v_0;
        $v_0 = parentNode.OutputSaveBehavior;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['OutputSaveBehavior'] = ((SP.DataConvert.fixupType(this.get_context(), $v_0)));
            delete parentNode.OutputSaveBehavior;
        }
    },
    
    translate: function SP_Translation_SyncTranslator$translate(inputFile, outputFile) {
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'Translate', [ inputFile, outputFile ]);
        $v_0.addQuery($v_2);
        $v_1 = new SP.Translation.TranslationItemInfo();
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    }
}


SP.Translation.SyncTranslatorPropertyNames = function SP_Translation_SyncTranslatorPropertyNames() {
}


SP.Translation.TranslationItemInfo = function SP_Translation_TranslationItemInfo() {
    SP.Translation.TranslationItemInfo.initializeBase(this);
}
SP.Translation.TranslationItemInfo.prototype = {
    $0_1: false,
    $2_1: null,
    $3_1: false,
    $4_1: false,
    $5_1: null,
    $8_1: false,
    $9_1: null,
    $B_1: 0,
    $D_1: false,
    $E_1: null,
    
    get_canceled: function SP_Translation_TranslationItemInfo$get_canceled() {
        return this.$0_1;
    },
    
    get_errorMessage: function SP_Translation_TranslationItemInfo$get_errorMessage() {
        return this.$2_1;
    },
    
    get_failed: function SP_Translation_TranslationItemInfo$get_failed() {
        return this.$3_1;
    },
    
    get_inProgress: function SP_Translation_TranslationItemInfo$get_inProgress() {
        return this.$4_1;
    },
    
    get_inputFile: function SP_Translation_TranslationItemInfo$get_inputFile() {
        return this.$5_1;
    },
    
    get_notStarted: function SP_Translation_TranslationItemInfo$get_notStarted() {
        return this.$8_1;
    },
    
    get_outputFile: function SP_Translation_TranslationItemInfo$get_outputFile() {
        return this.$9_1;
    },
    
    get_result: function SP_Translation_TranslationItemInfo$get_result() {
        return this.$B_1;
    },
    
    get_succeeded: function SP_Translation_TranslationItemInfo$get_succeeded() {
        return this.$D_1;
    },
    
    get_translationId: function SP_Translation_TranslationItemInfo$get_translationId() {
        return this.$E_1;
    },
    
    get_typeId: function SP_Translation_TranslationItemInfo$get_typeId() {
        return '{f1a935c2-8e02-42e8-9391-86bfe6d56f06}';
    },
    
    writeToXml: function SP_Translation_TranslationItemInfo$writeToXml(writer, serializationContext) {
        if (!writer) {
            throw Error.argumentNull('writer');
        }
        if (!serializationContext) {
            throw Error.argumentNull('serializationContext');
        }
        var $v_0 = [ 'Canceled', 'ErrorMessage', 'Failed', 'InProgress', 'InputFile', 'NotStarted', 'OutputFile', 'Result', 'Succeeded', 'TranslationId' ];
        SP.DataConvert.writePropertiesToXml(writer, this, $v_0, serializationContext);
        SP.ClientValueObject.prototype.writeToXml.call(this, writer, serializationContext);
    },
    
    initPropertiesFromJson: function SP_Translation_TranslationItemInfo$initPropertiesFromJson(parentNode) {
        SP.ClientValueObject.prototype.initPropertiesFromJson.call(this, parentNode);
        var $v_0;
        $v_0 = parentNode.Canceled;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.$0_1 = ($v_0);
            delete parentNode.Canceled;
        }
        $v_0 = parentNode.ErrorMessage;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.$2_1 = ($v_0);
            delete parentNode.ErrorMessage;
        }
        $v_0 = parentNode.Failed;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.$3_1 = ($v_0);
            delete parentNode.Failed;
        }
        $v_0 = parentNode.InProgress;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.$4_1 = ($v_0);
            delete parentNode.InProgress;
        }
        $v_0 = parentNode.InputFile;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.$5_1 = ($v_0);
            delete parentNode.InputFile;
        }
        $v_0 = parentNode.NotStarted;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.$8_1 = ($v_0);
            delete parentNode.NotStarted;
        }
        $v_0 = parentNode.OutputFile;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.$9_1 = ($v_0);
            delete parentNode.OutputFile;
        }
        $v_0 = parentNode.Result;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.$B_1 = ((SP.DataConvert.fixupType(null, $v_0)));
            delete parentNode.Result;
        }
        $v_0 = parentNode.Succeeded;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.$D_1 = ($v_0);
            delete parentNode.Succeeded;
        }
        $v_0 = parentNode.TranslationId;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.$E_1 = ($v_0);
            delete parentNode.TranslationId;
        }
    }
}


SP.Translation.TranslationJob = function SP_Translation_TranslationJob(context, targetLanguage) {
    SP.Translation.TranslationJob.initializeBase(this, [ context, SP.ClientUtility.getOrCreateObjectPathForConstructor(context, '{c85774be-554a-4c27-9b0c-a34ab1c86b0d}', arguments) ]);
}
SP.Translation.TranslationJob.newObject = function SP_Translation_TranslationJob$newObject(context, targetLanguage) {
    return new SP.Translation.TranslationJob(context, new SP.ObjectPathConstructor(context, '{c85774be-554a-4c27-9b0c-a34ab1c86b0d}', [ targetLanguage ]));
}
SP.Translation.TranslationJob.isServiceEnabled = function SP_Translation_TranslationJob$isServiceEnabled(context) {
    if (!context) {
        throw Error.argumentNull('context');
    }
    var $v_0;
    var $v_1 = new SP.ClientActionInvokeStaticMethod(context, '{c85774be-554a-4c27-9b0c-a34ab1c86b0d}', 'IsServiceEnabled', null);
    context.addQuery($v_1);
    $v_0 = new SP.BooleanResult();
    context.addQueryIdAndResultObject($v_1.get_id(), $v_0);
    return $v_0;
}
SP.Translation.TranslationJob.cancelJob = function SP_Translation_TranslationJob$cancelJob(context, jobId) {
    if (!context) {
        throw Error.argumentNull('context');
    }
    var $v_0 = new SP.ClientActionInvokeStaticMethod(context, '{c85774be-554a-4c27-9b0c-a34ab1c86b0d}', 'CancelJob', [ jobId ]);
    context.addQuery($v_0);
}
SP.Translation.TranslationJob.enumerateSupportedFileExtensions = function SP_Translation_TranslationJob$enumerateSupportedFileExtensions(context) {
    if (!context) {
        throw Error.argumentNull('context');
    }
    var $v_0;
    var $v_1 = new SP.ClientActionInvokeStaticMethod(context, '{c85774be-554a-4c27-9b0c-a34ab1c86b0d}', 'EnumerateSupportedFileExtensions', null);
    context.addQuery($v_1);
    $v_0 = (([]));
    context.addQueryIdAndResultObject($v_1.get_id(), $v_0);
    return $v_0;
}
SP.Translation.TranslationJob.isFileExtensionSupported = function SP_Translation_TranslationJob$isFileExtensionSupported(context, extension) {
    if (!context) {
        throw Error.argumentNull('context');
    }
    var $v_0;
    var $v_1 = new SP.ClientActionInvokeStaticMethod(context, '{c85774be-554a-4c27-9b0c-a34ab1c86b0d}', 'IsFileExtensionSupported', [ extension ]);
    context.addQuery($v_1);
    $v_0 = new SP.BooleanResult();
    context.addQueryIdAndResultObject($v_1.get_id(), $v_0);
    return $v_0;
}
SP.Translation.TranslationJob.getMaximumFileSize = function SP_Translation_TranslationJob$getMaximumFileSize(context, extension) {
    if (!context) {
        throw Error.argumentNull('context');
    }
    var $v_0;
    var $v_1 = new SP.ClientActionInvokeStaticMethod(context, '{c85774be-554a-4c27-9b0c-a34ab1c86b0d}', 'GetMaximumFileSize', [ extension ]);
    context.addQuery($v_1);
    $v_0 = new SP.IntResult();
    context.addQueryIdAndResultObject($v_1.get_id(), $v_0);
    return $v_0;
}
SP.Translation.TranslationJob.enumerateSupportedLanguages = function SP_Translation_TranslationJob$enumerateSupportedLanguages(context) {
    if (!context) {
        throw Error.argumentNull('context');
    }
    var $v_0;
    var $v_1 = new SP.ClientActionInvokeStaticMethod(context, '{c85774be-554a-4c27-9b0c-a34ab1c86b0d}', 'EnumerateSupportedLanguages', null);
    context.addQuery($v_1);
    $v_0 = (([]));
    context.addQueryIdAndResultObject($v_1.get_id(), $v_0);
    return $v_0;
}
SP.Translation.TranslationJob.isLanguageSupported = function SP_Translation_TranslationJob$isLanguageSupported(context, language) {
    if (!context) {
        throw Error.argumentNull('context');
    }
    var $v_0;
    var $v_1 = new SP.ClientActionInvokeStaticMethod(context, '{c85774be-554a-4c27-9b0c-a34ab1c86b0d}', 'IsLanguageSupported', [ language ]);
    context.addQuery($v_1);
    $v_0 = new SP.BooleanResult();
    context.addQueryIdAndResultObject($v_1.get_id(), $v_0);
    return $v_0;
}
SP.Translation.TranslationJob.prototype = {
    
    get_jobId: function SP_Translation_TranslationJob$get_jobId() {
        this.checkUninitializedProperty('JobId');
        return ((this.get_objectData().get_properties()['JobId']));
    },
    
    get_name: function SP_Translation_TranslationJob$get_name() {
        this.checkUninitializedProperty('Name');
        return ((this.get_objectData().get_properties()['Name']));
    },
    set_name: function SP_Translation_TranslationJob$set_name(value) {
        this.get_objectData().get_properties()['Name'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'Name', value));
        }
        return value;
    },
    
    get_outputSaveBehavior: function SP_Translation_TranslationJob$get_outputSaveBehavior() {
        this.checkUninitializedProperty('OutputSaveBehavior');
        return ((this.get_objectData().get_properties()['OutputSaveBehavior']));
    },
    set_outputSaveBehavior: function SP_Translation_TranslationJob$set_outputSaveBehavior(value) {
        this.get_objectData().get_properties()['OutputSaveBehavior'] = value;
        if ((this.get_context())) {
            this.get_context().addQuery(new SP.ClientActionSetProperty(this, 'OutputSaveBehavior', value));
        }
        return value;
    },
    
    initPropertiesFromJson: function SP_Translation_TranslationJob$initPropertiesFromJson(parentNode) {
        SP.ClientObject.prototype.initPropertiesFromJson.call(this, parentNode);
        var $v_0;
        $v_0 = parentNode.JobId;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['JobId'] = ($v_0);
            delete parentNode.JobId;
        }
        $v_0 = parentNode.Name;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['Name'] = ($v_0);
            delete parentNode.Name;
        }
        $v_0 = parentNode.OutputSaveBehavior;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['OutputSaveBehavior'] = ((SP.DataConvert.fixupType(this.get_context(), $v_0)));
            delete parentNode.OutputSaveBehavior;
        }
    },
    
    addFile: function SP_Translation_TranslationJob$addFile(inputFile, outputFile) {
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'AddFile', [ inputFile, outputFile ]);
        $v_0.addQuery($v_1);
    },
    
    addFolder: function SP_Translation_TranslationJob$addFolder(inputFolder, outputFolder, recursion) {
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'AddFolder', [ inputFolder, outputFolder, recursion ]);
        $v_0.addQuery($v_2);
        $v_1 = new SP.BooleanResult();
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    },
    
    addLibrary: function SP_Translation_TranslationJob$addLibrary(inputList, outputList) {
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'AddLibrary', [ inputList, outputList ]);
        $v_0.addQuery($v_2);
        $v_1 = new SP.BooleanResult();
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    },
    
    start: function SP_Translation_TranslationJob$start() {
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'Start', null);
        $v_0.addQuery($v_1);
    }
}


SP.Translation.TranslationJobPropertyNames = function SP_Translation_TranslationJobPropertyNames() {
}


SP.Translation.TranslationJobInfo = function SP_Translation_TranslationJobInfo() {
    SP.Translation.TranslationJobInfo.initializeBase(this);
}
SP.Translation.TranslationJobInfo.prototype = {
    $0_1: false,
    $1_1: null,
    $6_1: null,
    $7_1: null,
    $A_1: false,
    $C_1: null,
    
    get_canceled: function SP_Translation_TranslationJobInfo$get_canceled() {
        return this.$0_1;
    },
    
    get_cancelTime: function SP_Translation_TranslationJobInfo$get_cancelTime() {
        return this.$1_1;
    },
    
    get_jobId: function SP_Translation_TranslationJobInfo$get_jobId() {
        return this.$6_1;
    },
    
    get_name: function SP_Translation_TranslationJobInfo$get_name() {
        return this.$7_1;
    },
    
    get_partiallySubmitted: function SP_Translation_TranslationJobInfo$get_partiallySubmitted() {
        return this.$A_1;
    },
    
    get_submittedTime: function SP_Translation_TranslationJobInfo$get_submittedTime() {
        return this.$C_1;
    },
    
    get_typeId: function SP_Translation_TranslationJobInfo$get_typeId() {
        return '{39b8cbdb-b9f4-4a97-bcf9-b2f28359bf2a}';
    },
    
    writeToXml: function SP_Translation_TranslationJobInfo$writeToXml(writer, serializationContext) {
        if (!writer) {
            throw Error.argumentNull('writer');
        }
        if (!serializationContext) {
            throw Error.argumentNull('serializationContext');
        }
        var $v_0 = [ 'Canceled', 'CancelTime', 'JobId', 'Name', 'PartiallySubmitted', 'SubmittedTime' ];
        SP.DataConvert.writePropertiesToXml(writer, this, $v_0, serializationContext);
        SP.ClientValueObject.prototype.writeToXml.call(this, writer, serializationContext);
    },
    
    initPropertiesFromJson: function SP_Translation_TranslationJobInfo$initPropertiesFromJson(parentNode) {
        SP.ClientValueObject.prototype.initPropertiesFromJson.call(this, parentNode);
        var $v_0;
        $v_0 = parentNode.Canceled;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.$0_1 = ($v_0);
            delete parentNode.Canceled;
        }
        $v_0 = parentNode.CancelTime;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.$1_1 = ($v_0);
            delete parentNode.CancelTime;
        }
        $v_0 = parentNode.JobId;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.$6_1 = ($v_0);
            delete parentNode.JobId;
        }
        $v_0 = parentNode.Name;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.$7_1 = ($v_0);
            delete parentNode.Name;
        }
        $v_0 = parentNode.PartiallySubmitted;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.$A_1 = ($v_0);
            delete parentNode.PartiallySubmitted;
        }
        $v_0 = parentNode.SubmittedTime;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.$C_1 = ($v_0);
            delete parentNode.SubmittedTime;
        }
    }
}


SP.Translation.TranslationJobStatus = function SP_Translation_TranslationJobStatus(context, jobId) {
    SP.Translation.TranslationJobStatus.initializeBase(this, [ context, SP.ClientUtility.getOrCreateObjectPathForConstructor(context, '{a41fff40-2ff3-44e6-9436-b3e3ba60e174}', arguments) ]);
}
SP.Translation.TranslationJobStatus.newObject = function SP_Translation_TranslationJobStatus$newObject(context, jobId) {
    return new SP.Translation.TranslationJobStatus(context, new SP.ObjectPathConstructor(context, '{a41fff40-2ff3-44e6-9436-b3e3ba60e174}', [ jobId ]));
}
SP.Translation.TranslationJobStatus.getAllActiveJobs = function SP_Translation_TranslationJobStatus$getAllActiveJobs(context) {
    if (!context) {
        throw Error.argumentNull('context');
    }
    var $v_0;
    var $v_1 = new SP.ClientActionInvokeStaticMethod(context, '{a41fff40-2ff3-44e6-9436-b3e3ba60e174}', 'GetAllActiveJobs', null);
    context.addQuery($v_1);
    $v_0 = (([]));
    context.addQueryIdAndResultObject($v_1.get_id(), $v_0);
    return $v_0;
}
SP.Translation.TranslationJobStatus.getAllJobs = function SP_Translation_TranslationJobStatus$getAllJobs(context) {
    if (!context) {
        throw Error.argumentNull('context');
    }
    var $v_0;
    var $v_1 = new SP.ClientActionInvokeStaticMethod(context, '{a41fff40-2ff3-44e6-9436-b3e3ba60e174}', 'GetAllJobs', null);
    context.addQuery($v_1);
    $v_0 = (([]));
    context.addQueryIdAndResultObject($v_1.get_id(), $v_0);
    return $v_0;
}
SP.Translation.TranslationJobStatus.prototype = {
    
    get_canceled: function SP_Translation_TranslationJobStatus$get_canceled() {
        this.checkUninitializedProperty('Canceled');
        return ((this.get_objectData().get_properties()['Canceled']));
    },
    
    get_count: function SP_Translation_TranslationJobStatus$get_count() {
        this.checkUninitializedProperty('Count');
        return ((this.get_objectData().get_properties()['Count']));
    },
    
    get_failed: function SP_Translation_TranslationJobStatus$get_failed() {
        this.checkUninitializedProperty('Failed');
        return ((this.get_objectData().get_properties()['Failed']));
    },
    
    get_inProgress: function SP_Translation_TranslationJobStatus$get_inProgress() {
        this.checkUninitializedProperty('InProgress');
        return ((this.get_objectData().get_properties()['InProgress']));
    },
    
    get_name: function SP_Translation_TranslationJobStatus$get_name() {
        this.checkUninitializedProperty('Name');
        return ((this.get_objectData().get_properties()['Name']));
    },
    
    get_notStarted: function SP_Translation_TranslationJobStatus$get_notStarted() {
        this.checkUninitializedProperty('NotStarted');
        return ((this.get_objectData().get_properties()['NotStarted']));
    },
    
    get_succeeded: function SP_Translation_TranslationJobStatus$get_succeeded() {
        this.checkUninitializedProperty('Succeeded');
        return ((this.get_objectData().get_properties()['Succeeded']));
    },
    
    initPropertiesFromJson: function SP_Translation_TranslationJobStatus$initPropertiesFromJson(parentNode) {
        SP.ClientObject.prototype.initPropertiesFromJson.call(this, parentNode);
        var $v_0;
        $v_0 = parentNode.Canceled;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['Canceled'] = ($v_0);
            delete parentNode.Canceled;
        }
        $v_0 = parentNode.Count;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['Count'] = ($v_0);
            delete parentNode.Count;
        }
        $v_0 = parentNode.Failed;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['Failed'] = ($v_0);
            delete parentNode.Failed;
        }
        $v_0 = parentNode.InProgress;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['InProgress'] = ($v_0);
            delete parentNode.InProgress;
        }
        $v_0 = parentNode.Name;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['Name'] = ($v_0);
            delete parentNode.Name;
        }
        $v_0 = parentNode.NotStarted;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['NotStarted'] = ($v_0);
            delete parentNode.NotStarted;
        }
        $v_0 = parentNode.Succeeded;
        if (!SP.ScriptUtility.isUndefined($v_0)) {
            this.get_objectData().get_properties()['Succeeded'] = ($v_0);
            delete parentNode.Succeeded;
        }
    },
    
    getItems: function SP_Translation_TranslationJobStatus$getItems(types) {
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'GetItems', [ types ]);
        $v_0.addQuery($v_2);
        $v_1 = (([]));
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    },
    
    getAllItems: function SP_Translation_TranslationJobStatus$getAllItems() {
        var $v_0 = this.get_context();
        var $v_1;
        var $v_2 = new SP.ClientActionInvokeMethod(this, 'GetAllItems', null);
        $v_0.addQuery($v_2);
        $v_1 = (([]));
        $v_0.addQueryIdAndResultObject($v_2.get_id(), $v_1);
        return $v_1;
    },
    
    refresh: function SP_Translation_TranslationJobStatus$refresh() {
        var $v_0 = this.get_context();
        var $v_1 = new SP.ClientActionInvokeMethod(this, 'Refresh', null);
        $v_0.addQuery($v_1);
    }
}


SP.Translation.TranslationJobStatusPropertyNames = function SP_Translation_TranslationJobStatusPropertyNames() {
}


SP.Translation.VariationsTranslationTimerJob = function SP_Translation_VariationsTranslationTimerJob() {
}
SP.Translation.VariationsTranslationTimerJob.exportItems = function SP_Translation_VariationsTranslationTimerJob$exportItems(context, list, itemIds, addressesToEmail) {
    if (!context) {
        throw Error.argumentNull('context');
    }
    var $v_0 = new SP.ClientActionInvokeStaticMethod(context, '{0e043428-89f2-4747-b485-bc6d77c90a11}', 'ExportItems', [ list, itemIds, addressesToEmail ]);
    context.addQuery($v_0);
}
SP.Translation.VariationsTranslationTimerJob.exportItemsRequiringTranslation = function SP_Translation_VariationsTranslationTimerJob$exportItemsRequiringTranslation(context, list, addressesToEmail) {
    if (!context) {
        throw Error.argumentNull('context');
    }
    var $v_0 = new SP.ClientActionInvokeStaticMethod(context, '{0e043428-89f2-4747-b485-bc6d77c90a11}', 'ExportItemsRequiringTranslation', [ list, addressesToEmail ]);
    context.addQuery($v_0);
}
SP.Translation.VariationsTranslationTimerJob.machineTranslateItems = function SP_Translation_VariationsTranslationTimerJob$machineTranslateItems(context, list, itemIds, addressesToEmail) {
    if (!context) {
        throw Error.argumentNull('context');
    }
    var $v_0 = new SP.ClientActionInvokeStaticMethod(context, '{0e043428-89f2-4747-b485-bc6d77c90a11}', 'MachineTranslateItems', [ list, itemIds, addressesToEmail ]);
    context.addQuery($v_0);
}
SP.Translation.VariationsTranslationTimerJob.machineTranslateItemsRequiringTranslation = function SP_Translation_VariationsTranslationTimerJob$machineTranslateItemsRequiringTranslation(context, list, addressesToEmail) {
    if (!context) {
        throw Error.argumentNull('context');
    }
    var $v_0 = new SP.ClientActionInvokeStaticMethod(context, '{0e043428-89f2-4747-b485-bc6d77c90a11}', 'MachineTranslateItemsRequiringTranslation', [ list, addressesToEmail ]);
    context.addQuery($v_0);
}
SP.Translation.VariationsTranslationTimerJob.importTranslationPackage = function SP_Translation_VariationsTranslationTimerJob$importTranslationPackage(context, translatorName, packageId, addressesToEmail) {
    if (!context) {
        throw Error.argumentNull('context');
    }
    var $v_0 = new SP.ClientActionInvokeStaticMethod(context, '{0e043428-89f2-4747-b485-bc6d77c90a11}', 'ImportTranslationPackage', [ translatorName, packageId, addressesToEmail ]);
    context.addQuery($v_0);
}


SP.Translation.SyncTranslator.registerClass('SP.Translation.SyncTranslator', SP.ClientObject);
SP.Translation.SyncTranslatorPropertyNames.registerClass('SP.Translation.SyncTranslatorPropertyNames');
SP.Translation.TranslationItemInfo.registerClass('SP.Translation.TranslationItemInfo', SP.ClientValueObject);
SP.Translation.TranslationJob.registerClass('SP.Translation.TranslationJob', SP.ClientObject);
SP.Translation.TranslationJobPropertyNames.registerClass('SP.Translation.TranslationJobPropertyNames');
SP.Translation.TranslationJobInfo.registerClass('SP.Translation.TranslationJobInfo', SP.ClientValueObject);
SP.Translation.TranslationJobStatus.registerClass('SP.Translation.TranslationJobStatus', SP.ClientObject);
SP.Translation.TranslationJobStatusPropertyNames.registerClass('SP.Translation.TranslationJobStatusPropertyNames');
SP.Translation.VariationsTranslationTimerJob.registerClass('SP.Translation.VariationsTranslationTimerJob');
SP.Translation.SyncTranslatorPropertyNames.outputSaveBehavior = 'OutputSaveBehavior';
SP.Translation.TranslationJobPropertyNames.jobId = 'JobId';
SP.Translation.TranslationJobPropertyNames.name = 'Name';
SP.Translation.TranslationJobPropertyNames.outputSaveBehavior = 'OutputSaveBehavior';
SP.Translation.TranslationJobStatusPropertyNames.canceled = 'Canceled';
SP.Translation.TranslationJobStatusPropertyNames.count = 'Count';
SP.Translation.TranslationJobStatusPropertyNames.failed = 'Failed';
SP.Translation.TranslationJobStatusPropertyNames.inProgress = 'InProgress';
SP.Translation.TranslationJobStatusPropertyNames.name = 'Name';
SP.Translation.TranslationJobStatusPropertyNames.notStarted = 'NotStarted';
SP.Translation.TranslationJobStatusPropertyNames.succeeded = 'Succeeded';

if( typeof(Sys) != "undefined" && Sys && Sys.Application ){
   Sys.Application.notifyScriptLoaded();
}
NotifyScriptLoadedAndExecuteWaitingJobs("SP.Translation.js");
