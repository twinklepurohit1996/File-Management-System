// Use 'secured' annotation to secure access
component secured {

    property name="diskService" inject="DiskService@cbfs";

    property name="folderService" inject="folderService";

    property name="UpChunk" inject="UpChunk@upchunk";

    property name="requestService" inject="coldbox:requestService";

    // Return after Wirebox finishes injecting dependencies
    function onDIComplete() {
        // Get our default disk
        variables.storage = diskService.defaultDisk();
    }

    /**
    * Executes before any actions
    */
    function preHandler( event, rc, prc, action, eventArguments ) {   
        prc.currentDirectory = event.getValue( "directory", 0 );
    }

    /**
    * GET /FileManager/index
    * List all the files in the current directory
    */
    function index( event, rc, prc ) {

        prc.allFilesAnddir = folderService.getFilesAnddir(prc.currentDirectory);

        prc.parentInfo = 0;
        if(prc.currentDirectory GT 0){
            var pData = folderService.getFolderInfo(prc.currentDirectory);
            prc.parentFolderId = pData.parentId;
        }

        prc.breadcrumbs = folderService.getBreadcrumb(prc.currentDirectory);

        arraySort(prc.breadcrumbs, function (e1, e2){
            return compare(e1.id, e2.id);
        });


        prc.listFolders = folderService.listFolders(0, prc.currentDirectory);

        event.setView( "FileManager/index" );
    }

    /**
    * GET /FileManager/upload
    * Form to upload files
    */
    function upload( event, rc, prc ) {
        var tempPath = expandPath("./tmp/");
		if(NOT directoryExists(tempPath)){
			directoryCreate(tempPath);
		}
        prc.breadcrumbs = folderService.getBreadcrumb(prc.currentDirectory);

        arraySort(prc.breadcrumbs, function (e1, e2){
            return compare(e1.id, e2.id);
        });
    }


    function getNextFileName(  required string fileFullName ) {
        var getListFiles = directoryList( expandPath("./.cbfs/"), false, "query" );
        var fileName = listFirst(arguments.fileFullName, '.');
        var res = {};
        var r = queryExecute("SELECT * FROM getListFiles WHERE LOWER(name) = :name",{name:{value:arguments.fileFullName}},{dbtype:"query"});
        if(r.recordCount GT 0){
            var fileExt = listLast(arguments.fileFullName, '.');
            var fileName = listFirst(arguments.fileFullName, '.');
            var r = queryExecute("SELECT * FROM filemanager WHERE LOWER(name) = :name",{name:{value:arguments.fileFullName}});
            var temp  = r.versionNo + 1;
            var r = queryExecute("UPDATE filemanager SET versionNo=:versionNo WHERE LOWER(name) = :name",{name:{value:arguments.fileFullName},versionNo:{value:temp}});
            var listTemp = "";
            for (var i = 1; i <= Len( temp ); i++) {
                listTemp = listAppend(listTemp, Mid( temp, i, 1 ),'.');
            }

            res['fileName'] = fileName & "_V" & listTemp & "." & fileExt;
            res['versionNo'] = temp;
        }
        return res;
    }

    /**
    * POST /FileManager/store
    * Store an uploaded file
    */
    function store( event, rc, prc ) {
        var finalResult = UpChunk.handleUpload( arguments.rc );
        var res = {};
        if(!finalResult.ISPARTIAL){
            if(fileExists(finalResult.FINALFILE)){
                var disPath = expandPath("./.cbfs/#rc.fileFullName#");
                if (fileExists(disPath)) {
                    var getNextFileName = getNextFileName(rc.fileFullName);
                    disPath = expandPath("./.cbfs/#getNextFileName.fileName#");
                    cffile(action = "rename" , destination = "#disPath#", source = "#finalResult.FINALFILE#", mode = 665);
                    var formData = {name: getNextFileName.fileName, parentId: rc.directory, size: rc.fileSize, id:0, isdir:0, versionNo: getNextFileName.versionNo};
                } else {
                    cffile(action = "rename" , destination = "#disPath#", source = "#finalResult.FINALFILE#", mode = 665);
                    var formData = {name: rc.fileFullName, parentId: rc.directory, size: rc.fileSize, id:0, isdir:0, versionNo:100};
                }
            }
            res = folderService.createFolder(formData);
        }

        event.renderData( data=res, type="JSON" );
    }

    /**
    * GET /FileManager/read
    * Display the contents of a file
    */
    function download( event, rc, prc ) {

        var pData = folderService.getFolderInfo(prc.currentDirectory);

        var realPath = expandPath("./.cbfs/#pData.name#");

        event.setHTTPHeader( name="expires", 		value="#GetHttpTimeString( now() )#" )
			.setHTTPHeader(  name="pragma", 		value="no-cache" )
			.setHTTPHeader(  name="cache-control",  value="no-cache, no-store, must-revalidate" );

        if (fileExists(realPath)) {
            variables.requestService.getContext().sendFile(
                file        = realPath,
                disposition = "attachment",
                mimeType    = getPageContext().getServletContext().getMimeType( realPath )
            );
        }else{
            event.renderData( data="<h1>Page Not Found</h1>", statusCode=404 );
        }
    }

    /**
    * POST /FileManager/delete
    * Delete a file
    */
    function delete( event, rc, prc ) {
        var res = folderService.delete(prc.currentDirectory);
        if (rc.isdir EQ 1) {
            flash.put( "danger", "Folder '#rc.name#' deleted." );
        } else {
            flash.put( "danger", "File '#rc.name#' deleted." );
        }
        relocate( uri="/FileManager/index?directory=#rc.parentId#" );
    }

    
    /**
     * POST Create Directory
     * To create directory
     */
    function createDirectory( event, rc, prc ){
        
        var formData = event.getExcept( [ "event", "fieldnames", "method", "format" ] );

        var res = folderService.createFolder(formData);

        if (res.success) {
            flash.put( "success", res.message );
        }

        event.renderData( data=res, type="JSON" );
    }

    
    /**
     * Edit directory
     * To edit directory
     */
    function editDirectory( event, rc, prc ){

        var formData = event.getExcept( [ "event", "fieldnames", "method", "format" ] );

        var res = folderService.editFolder(formData);

        if (res.success) {
            flash.put( "success", res.message );
        }
        
        event.renderData( data=res, type="JSON" );
    }


    
    /**
     * moveDirectory
     */
    function moveDirectory( event, rc, prc ){

        var res = folderService.moveDirectory(rc.moveId, rc.fileId);

        if (res.success) {
            flash.put( "success", res.message );
        }

        relocate( uri="/FileManager/index?directory=#rc.dirId#" );
    }
    
}
