<cfoutput>
    <div class="container">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between mb-2">
                    <h1>File Manager</h1>
                    <div>
                        <cfif prc.currentDirectory GT 0>
                            <a class="btn btn-primary dropdown-toggle" href="##" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false">
                                <i class="fas fa-arrow-left" title="Back"></i>
                            </a>
                            
                            <ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
                                <a href="/FileManager/index"><li class="dropdown-item"><i class="fas fa-home" title="Home"></i></li></a>
                                <cfset c = 0>
                                <cfif arrayLen(prc.breadcrumbs) GT 0>
                                    <cfloop array="#prc.breadcrumbs#" index="b">
                                        <cfset c = c +1>
                                        <cfif c EQ arrayLen(prc.breadcrumbs)>
                                            <li class="dropdown-item active" aria-current="page">#b.name#</li>
                                        <cfelse>
                                            <a href="/FileManager/index?directory=#b.id#"><li class="dropdown-item">#b.name#</li></a>
                                        </cfif>
                                    </cfloop>
                                </cfif>
                            </ul>
                        </cfif>
                        <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="##exampleModal">
                            <i class="fas fa-folder-plus" title="Create Folder"></i>
                        </button>
                        <cfif prc.currentDirectory GT 0>
                            <a href="/FileManager/upload?directory=#prc.currentDirectory#" class="btn btn-primary">
                                <i class="fas fa-upload" title="Upload File"></i>
                            </a>
                        </cfif>
                    </div>
                </div>
                <cfif arrayLen(prc.breadcrumbs) GT 0>
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb">
                            <li class="breadcrumb-item"><a href="/FileManager/index"><i class="fas fa-home" title="Home"></i></a></li>
                            <cfset c = 0>
                            <cfloop array="#prc.breadcrumbs#" index="b">
                                <cfset c = c +1>
                                <cfif c EQ arrayLen(prc.breadcrumbs)>
                                    <li class="breadcrumb-item active" aria-current="page">#b.name#</li>
                                <cfelse>
                                    <li class="breadcrumb-item"><a href="/FileManager/index?directory=#b.id#">#b.name#</a></li>
                                </cfif>
                            </cfloop>
                        </ol>
                    </nav>
                </cfif>
                <table class="table">
                    <thead>
                        <tr>
                            <th scope="col">Filename</th>
                            <th scope="col">Last Modified</th>
                            <th scope="col">Size</th>
                            <th scope="col">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfloop query="prc.allFilesAnddir">
                            <tr>
                                <td>
                                    <cfif prc.allFilesAnddir.isdir EQ 0>
                                        <i class="fas fa-file text-primary" title="File"></i>
                                        <a href="/FileManager/download?directory=#prc.allFilesAnddir.id#">
                                            #prc.allFilesAnddir.name#
                                        </a>
                                    <cfelse>
                                        <i class="fas fa-folder text-primary" title="Folder"></i>
                                        <a href="/FileManager/index?directory=#prc.allFilesAnddir.id#">
                                            #prc.allFilesAnddir.name#
                                        </a>
                                    </cfif>
                                    </td>
                                <td>#dateTimeFormat( prc.allFilesAnddir.modified_date )#</td>
                                <td>#prc.allFilesAnddir.size#</td>
                                <td>
                                    <cfif prc.allFilesAnddir.isdir EQ 1>
                                        <a href="##" data-id="#prc.allFilesAnddir.id#" data-name="#prc.allFilesAnddir.name#" class="edit"><i class="fas fa-edit" title="Edit"></i></a>
                                    <cfelse>
                                        <a href="/FileManager/download?directory=#prc.allFilesAnddir.id#"><i class="fas fa-download" title="Download"></i></a>
                                    </cfif>
                                    <cfif prc.allFilesAnddir.isdir EQ 1>
                                        <a href="##" data-id="#prc.allFilesAnddir.id#" data-name="#prc.allFilesAnddir.name#" class="delete" data-dir=1 data-parentID="#prc.allFilesAnddir.parentId#"><i class="fas fa-trash" title="Delete"></i></a>
                                    <cfelse>
                                        <a href="##" data-id="#prc.allFilesAnddir.id#" data-name="#prc.allFilesAnddir.name#" class="delete" data-dir=0 data-parentID="#prc.allFilesAnddir.parentId#"><i class="fas fa-trash" title="Delete"></i></a>
                                        <a href="##" data-id="#prc.allFilesAnddir.id#" data-dirID="#prc.currentDirectory#" data-bs-toggle="modal" data-bs-target="##moveModal" class="move"><i class="fas fa-arrow-right" title="Move Folder"></i></a>
                                    </cfif>
                                </td>
                            </tr>
                        </cfloop>
                        <cfif prc.allFilesAnddir.recordcount EQ 0>
                            <tr>
                                <td colspan="4">There are no files here. Super lame.</td>
                            </tr>
                        </cfif>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!-- Modal -->
    <div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <form action="" method="post" id="createFolder">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Create Folder</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-danger alert-dismissible fade d-none" role="alert" id="alert"></div>
                        <div class="mb-3" id="createFolderDiv">
                            <input type="hidden" name="parentId" value="#prc.currentDirectory#">
                            <label for="formFile" class="form-label" id="nameLabel">Create Folder</label>
                            <input type="text" class="form-control" id="name" name="name" placeholder="Type Folder Name" autocomplete="off">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger me-auto" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary" id="submit">Create Folder</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    <!-- Modal -->
    <div class="modal fade" id="moveModal" tabindex="-1" aria-labelledby="moveModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <form action="#event.buildLink('FileManager.moveDirectory')#" method="post" id="moveFolder">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="moveModalLabel">Move Folder</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-danger alert-dismissible fade d-none" role="alert" id="alertMove"></div>
                        <div class="mb-3" id="moveModalDiv">
                            <input type="hidden" id="fileId" name="fileId" value="">
                            <input type="hidden" id="dirId" name="dirId" value="">
                            <label for="formFile" class="form-label" id="nameMoveLabel">Move Folder</label>
                            <select class="form-select" name="moveId">
                                <option value="0">--Please select--</option>
                                <cfloop array="#prc.listFolders#" index="i">
                                    <option value="#i.id#">#i.name#</option>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-danger me-auto" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary" id="submit">Move Folder</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</cfoutput>
