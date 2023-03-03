component {

	
    /**
     * Create Folder
     */
    function createFolder(required struct formData) {

        var json  = {'success':false, 'message':''};
        var today = now();
        if(NOT structKeyExists(arguments.formData,"id")){
			arguments.formData.id = 0;
		}

        if(NOT structKeyExists(arguments.formData,"isdir")){
			arguments.formData.isdir = 1;
		}

        if(NOT structKeyExists(arguments.formData,"size")){
			arguments.formData.size = 0;
		}

		var q = new query();
		q.addParam( name = "name", value =arguments.formData.name , cfsqltype = "cf_sql_varchar" );
		q.addParam( name = "id", value = arguments.formData.id, cfsqltype = "cf_sql_integer" );
        q.addParam( name = "parentId", value = arguments.formData.parentId, cfsqltype = "cf_sql_integer" );
		var sql = 'SELECT name FROM filemanager WHERE name=:name AND id!=:id AND parentId=:parentId';
		q.setSQL(sql);
		var r = q.execute().getResult();
        if (r.recordCount EQ 1) {
            json  = {'success':false, 'message':'#arguments.formData.name# folder already exists'};
			return json;
        }
        
        var q = new query();
        q.addParam( name = "created_date", value = today, cfsqltype = "cf_sql_timestamp" );
        q.addParam( name = "isdir", value = arguments.formData.isdir, cfsqltype = "cf_sql_tinyint" );
        q.addParam( name = "size", value = arguments.formData.size, cfsqltype = "cf_sql_integer" );
        q.addParam( name = "parentId", value = arguments.formData.parentId, cfsqltype = "cf_sql_integer" );
        q.addParam( name = "name", value = arguments.formData.name, cfsqltype = "cf_sql_varchar" );
        if (arguments.formData.isdir EQ 1){
            q.addParam( name = "versionNo", value = 0, cfsqltype = "cf_sql_integer" );
        } else {
            q.addParam( name = "versionNo", value = "#arguments.formData.versionNo#", cfsqltype = "cf_sql_integer" );
        }
		var sql = 'INSERT INTO filemanager SET name=:name, isdir=:isdir, size=:size, created_date=:created_date, parentId=:parentId, versionNo=:versionNo';
		q.setSQL(sql);
		var r = q.execute().getPrefix();

        if (r.recordcount EQ 1) {
            if (arguments.formData.id EQ 0) {
                if (arguments.formData.isdir EQ 1) {
                    json  = {'success':true, 'message':'#arguments.formData.name# folder created', 'parentId': '#arguments.formData.parentId#'};
                } else {
                    json  = {'success':true, 'message':'#arguments.formData.name# file upload', 'parentId': '#arguments.formData.parentId#'};
                }
            }
        }

        return json;
    }

    function getFilesAnddir(required numeric folderId) {
		var q = new query();
		q.addParam( name = "id", value = arguments.folderId, cfsqltype = "cf_sql_integer" );
		var sql = 'SELECT * FROM filemanager WHERE parentId=:id';
		q.setSQL(sql);
		var r = q.execute().getResult();
        return r;
    }


    function getFolderInfo(required numeric folderId) {
		var q = new query();
		q.addParam( name = "id", value = arguments.folderId, cfsqltype = "cf_sql_integer" );
		var sql = 'SELECT * FROM filemanager WHERE id=:id';
		q.setSQL(sql);
		var r = q.execute().getResult();
        return r;
    } 
    
    function getBreadcrumb(required numeric folderId, array resArray = []) {
		var q = new query();
		q.addParam( name = "id", value = arguments.folderId, cfsqltype = "cf_sql_integer" );
		var sql = 'SELECT id, parentId, name FROM filemanager WHERE id=:id';
		q.setSQL(sql);
		var r = q.execute().getResult();

        if(r.recordCount GT 0){
            var res = { name : r.name , id :r.id};
            arrayAppend(arguments.resArray, res);
            arguments.resArray = getBreadcrumb(r.parentId, arguments.resArray);
        }

        return arguments.resArray;
    }

    function delete(required numeric folderId) {
        var q = new query();
		q.addParam( name = "id", value = arguments.folderId, cfsqltype = "cf_sql_integer" );
		var sql = 'SELECT * FROM filemanager WHERE id=:id';
		q.setSQL(sql);
		var r = q.execute().getResult();

        if(r.recordCount GT 0){
            var qx = new query();
            qx.addParam( name = "id", value = arguments.folderId, cfsqltype = "cf_sql_integer" );
            var sqlx = 'DELETE FROM filemanager WHERE id=:id';
            qx.setSQL(sqlx).execute();

            if(r.isdir EQ 0){
                var disPath = expandPath("./.cbfs/#r.name#");
                if (fileExists(disPath)) {
                    fileDelete(disPath);
                }
            }
        }
    }

    function editFolder(required struct formData) {
        var json  = {'success':false, 'message':''};

        var q = new query();
		q.addParam( name = "name", value =arguments.formData.name , cfsqltype = "cf_sql_varchar" );
		q.addParam( name = "editId", value = arguments.formData.editId, cfsqltype = "cf_sql_integer" );
		var sql = 'SELECT name FROM filemanager WHERE name=:name AND id!=:editId';
		q.setSQL(sql);
		var r = q.execute().getResult();
        if (r.recordCount EQ 1) {
            json  = {'success':false, 'message':'#arguments.formData.name# folder already exists'};
			return json;
        }

        var q = new query();
		q.addParam( name = "editId", value = arguments.formData.editId, cfsqltype = "cf_sql_integer" );
        q.addParam( name = "name", value = arguments.formData.name, cfsqltype = "cf_sql_varchar" );
        var sql = 'UPDATE filemanager SET name=:name WHERE id=:editId';
        q.setSQL(sql);
        var r = q.execute().getPrefix();
        
        if (r.recordcount EQ 1) {
            json  = {'success':true, 'message':'#arguments.formData.name# folder edited'};
        }

        var q = new query();
        q.addParam( name = "editId", value = arguments.formData.editId, cfsqltype = "cf_sql_integer" );
        var sql = 'SELECT parentId from filemanager WHERE id=:editId';
        q.setSQL(sql);
        var r = q.execute().getResult();
        if (r.recordcount EQ 1) {
            json['parentId'] = r.parentId;
        }
        return json;
    }

    function getDirById(required struct formData) {
        var json  = false;

        var q = new query();
        q.addParam( name = "name", value =arguments.formData.name , cfsqltype = "cf_sql_varchar" );
        q.addParam( name = "parentId", value = arguments.formData.parentId, cfsqltype = "cf_sql_integer" );
        var sql = 'SELECT name FROM filemanager WHERE name=:name AND parentId=:parentId';
        q.setSQL(sql);
        var r = q.execute().getResult();
        if (r.recordcount EQ 1) {
            json  = true;
        }
        return json;
    }

    function listFolders(required numeric parentId, required numeric id,  string parentName = '', array resArray = []) {
		var q = new query();
		q.addParam( name = "parentId", value = arguments.parentId, cfsqltype = "cf_sql_integer" );
		var sql = 'SELECT id, parentId, name FROM filemanager WHERE parentId=:parentId AND isdir=1 ORDER BY id';
		q.setSQL(sql);
		var r = q.execute().getResult();
        if(r.recordCount GT 0){
            for (var x in r) {
                var FolderName = x.name;
                if(len(arguments.parentName) GT 0){
                    FolderName  = arguments.parentName&" > "&x.name;
                }
                var res = {name: FolderName, id: x.id};
                if (arguments.id NEQ x.id) {
                    arrayAppend(arguments.resArray, res);
                }
                listFolders(x.id, arguments.id,  FolderName, arguments.resArray);
            }
        }
        return arguments.resArray;
    }

    function moveDirectory(required numeric parentId, required numeric id) {
        var json  = {'success':false, 'message':''};
        var q = new query();
		q.addParam( name = "parentId", value = arguments.parentId, cfsqltype = "cf_sql_integer" );
        q.addParam( name = "id", value = arguments.id, cfsqltype = "cf_sql_integer" );
		var sql = 'UPDATE filemanager SET parentId=:parentId WHERE id=:id';
		q.setSQL(sql);
		var r = q.execute().getPrefix();
        if (r.recordcount EQ 1) {
            var q = new query();
            q.addParam( name = "parentId", value = arguments.parentId, cfsqltype = "cf_sql_integer" );
            var sql = 'SELECT name from filemanager WHERE id=:parentId';
            q.setSQL(sql);
            var r = q.execute().getResult();
            var json  = {'success':true, 'message':'File moved to #r.name#'};
        }
        return json;
    }
}