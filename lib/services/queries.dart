class ApiQuery
{
  static String signupQuery = "mutation customerCreate(\$input: CustomerCreateInput!) { customerCreate(input: \$input) { customer { id email } customerUserErrors { message } } }";
  static String loginQuery = "mutation customerAccessTokenCreate(\$input: CustomerAccessTokenCreateInput!) { customerAccessTokenCreate(input: \$input) { customerAccessToken { accessToken expiresAt } customerUserErrors { message } } }";
  static String getProfileQuery = "query (\$customerAccessToken: String!) { customer(customerAccessToken: \$customerAccessToken) { id firstName lastName email phone } }";
  static String updateProfileQuery = "mutation customerUpdate(\$customerAccessToken: String!, \$customer: CustomerUpdateInput!) { customerUpdate(customerAccessToken: \$customerAccessToken, customer: \$customer) { customer { id firstName lastName email phone } customerUserErrors { message } } }";
  static String updatePasswordQuery = "mutation customerUpdate(\$customerAccessToken: String!, \$customer: CustomerUpdateInput!) { customerUpdate(customerAccessToken: \$customerAccessToken, customer: \$customer) { customer { id email } customerUserErrors { message } } }";
  static String getAllAddressQuery = "query (\$customerAccessToken: String!) { customer(customerAccessToken: \$customerAccessToken) { addresses(first: 10) { edges { node { id firstName lastName address1 address2 city province country zip phone } } } defaultAddress { id } } }";
  static String addAddressQuery = "mutation customerAddressCreate(\$customerAccessToken: String!, \$address: MailingAddressInput!) { customerAddressCreate(customerAccessToken: \$customerAccessToken, address: \$address) { customerAddress { id firstName lastName address1 address2 city province country zip phone } customerUserErrors { message } } }";
  //static String signupQuery = "";
}