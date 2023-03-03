<cfoutput>
    <div class="container">
        <div class="row">
            <div class="col-12">
                <div class="d-flex justify-content-between mb-2">
                    <h1>Upload File</h1>
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
                <div class="alert alert-success alert-dismissible fade d-none" role="alert" id="alert"></div>
                <form action="/FileManager/store?directory=#prc.currentDirectory#" class="dropzone" id="myGreatDropzone"></form>
            </div>
        </div>
    </div>
</cfoutput>