<cfoutput>
    <!doctype html>
    <html lang="en">
        <head>
            <meta charset="utf-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <!--- Bootstrap 5 --->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
            <title>Serco Demo</title>
            <!--- Icons for demo --->
            <script src="https://kit.fontawesome.com/b39120cbd1.js" crossorigin="anonymous"></script>
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
            <script src="https://cdn.jsdelivr.net/combine/npm/jquery-validation@1.19.5,npm/jquery-validation@1.19.5/dist/additional-methods.min.js"></script>
            <link rel="stylesheet" href="https://unpkg.com/dropzone@5/dist/min/dropzone.min.css" type="text/css" />
            <script src="https://unpkg.com/dropzone@5/dist/min/dropzone.min.js"></script>
        </head>
        <body>
            <div class="mt-5">
                <!--- If messages/alerts are in our flash RAM, display them --->
                <cfloop array="#[ 'info', 'error', 'warning', 'danger', 'success']#" index="flashKey">
                    <cfif flash.exists( flashKey )>
                        <div class="container">
                            <div class="row">
                                <div class="col-12">
                                    <div class="alert alert-#flashKey#">
                                        #flash.get( flashKey )#
                                    </div>
                                </div>
                            </div>
                        </div>
                    </cfif>
                </cfloop>

                <!--- Render our view. Default view is FileManager.index --->
                #renderView()#
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        </body>
    </html>
</cfoutput>