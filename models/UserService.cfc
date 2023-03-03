component {

	/**
	 * Verify if the incoming username/password are valid credentials.
	 *
	 * @username The username
	 * @password The password
	 */
	boolean function isValidCredentials( required username, required password ) {
        return username == "admin" and password == "admin";
    }

	/**
	 * Retrieve a user by username
	 *
	 * @return User that implements IAuthUser
	 */
	function retrieveUserByUsername( required username ) {
        return new models.User();
    }

	/**
	 * Retrieve a user by unique identifier
	 *
	 * @id The unique identifier
	 *
	 * @return User that implements IAuthUser
	 */
	function retrieveUserById( required id ) {
        return new models.User();
    }
}