component {
    /**
    * POST /auth/authenticate
    * Authenticate a user from the login page
    */
    function authenticate( event, rc, prc ) {
        try {
            // Use cbsecurity's auth().authenticate() method to authenticate our user
            var user = auth().authenticate( rc.username, rc.password ); // throw InvalidCredentails exceptions if bad login
            // Login our user
            auth().login( user );
            // Notify that login was successful
            flash.put( "success", "Good login" );
            // Redirect to file manager
            relocate( "FileManager.index" );
        } catch ( InvalidCredentials var e ) {
            // Notify that login was unsuccessful
            flash.put( "warning", "Bad login" );
            // Redirect to the login page
            relocate( "Auth.login" );
        }
    }
    /**
    * GET /auth/logout
    * Logout a user
    */
    function logout( event, rc, prc ) {
        // Use cbsecurity's auth().logout() method to logout our user
        auth().logout();
        // Redirect us back to the login apge
        relocate( "Auth.login" );
    }
}