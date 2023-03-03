component {


    function getId() {
        return 1;
    }

    /**
     * Verify if the user has one or more of the passed in permissions
     *
     * @permission One or a list of permissions to check for access
     *
     */
    boolean function hasPermission( required permission ) {
        if ( permission == "read-/file1.txt" ) {
            return true;
        }
        return true;
    }

    /**
     * Shortcut to verify it the user is logged in or not.
     */
    boolean function isLoggedIn() {
        return true;
    }
}