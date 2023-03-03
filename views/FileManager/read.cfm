<cfoutput>
    <div class="container">
        <div class="row">
            <div class="d-flex justify-content-between">
                <h1>#prc.filePath#</h1>
                <div><a href="/FileManager/index?directory=#prc.currentDirectory#" class="btn btn-primary"><i class="fas fa-chevron-circle-left"></i></a></div>
            </div>
            <div><pre><code>#encodeForHTML( prc.contents )#</code></pre></div>
        </div>
    </div>
</cfoutput>