<cfoutput>
    <div class="container">
        <div class="row">
            <div class="col-12">
                <h1>Login</h1>
                <form method="post" action="/Auth/authenticate">
                    <div class="mb-3">
                        <label for="exampleInputEmail1" class="form-label">Username</label>
                        <input name="username" type="text" class="form-control">
                        <div id="emailHelp" class="form-text">If you don't remember your username, you are out of luck.</div>
                    </div>
                    <div class="mb-3">
                        <label for="exampleInputPassword1" class="form-label">Password</label>
                        <input name="password" type="password" class="form-control" id="exampleInputPassword1">
                    </div>
                    <button type="submit" class="btn btn-primary">Submit</button>
                </form>
            </div>
        </div>
    </div>
</cfoutput>