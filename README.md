# Using the API

Active API testing portal:

  [https://microclimates.docs.apiary.io](https://microclimates.docs.apiary.io)

The document below is copied from the [apiary.apib](https://github.com/microclimates/api-v2/blob/master/apiary.apib) file in this repository.

---

FORMAT: 1A  
HOST: https://microclimates.com

# Climate Conrol API

The Microclimates Climate Control API allows developers to interact with Microclimates sites
and devices from the context of a user.

It offers all functionality used in the Microclimates UI, and additional
items for posting and retrieving device data.

# Authorization

All API interactions must be authorized by passing
the user authentication token in the HTTP Authorization header.
```
Authorization: Bearer {token}
```
This token is available in the User Settings section within the Microclimates 
application.

# Security

The API processes only HTTPS requests, securing the content from
observation while traveling over the network. 

The resource ID and request parameters may be part of the URL, but all resource
data is passed in the request/response body, as to not get logged on the server. 

If you feel your API token has been compromised, the  token can be revoked and replaced
within the Microclimates application.

# Compatibility

This major API version (v2) will evolve with additional functionality. All changes
will be made backwardly compatible as long as your API client can be flexible to allow
for additional response fields.

Any incompatible changes will be deferred to the next major version (v3).

# Requests

The following sections of the HTTP request are handled the same for each API interaction.

## Request URL

The request URL is made with the following parts, in order

**Scheme** - `https://`  
**Server** - `microclimates.com`  
**API Path** - `/api/v2`  
**Resource Type** - `/{resource type}`  
**Resource ID** - `/{resource id}` (not used for *POST*)  
**Query Parameters** - `?param1=value1&param2=value2` (specialized for queries)

## Request Headers

The following request headers are recognized

**authorization** - (see Authorization section above)  
**content-type** - Describes the format of the content body one of `application/json` or `application/x-www-form-urlencoded`  
**accept-encoding** - Supplied if your client accepts gzip, deflate, etc. encoding  
**if-none-match** - Supplied on *GET* requests if you want a `304` response instead of the response body if the body hasn't changed. The value is that of a prior `etag` response header value.

## Content Body

The format of data supplied in the request body is based on the `Content-Type` header
 (see above).

**Example: applicaton/json**
```
{
    "id": "some-resource-id",
    "name":"Resource Name",
    ...
}
```

JSON data may be, but is not required to be pretty printed as in the above example.

**Example: application/x-www-form-urlencoded**
```
id=some-resource-id&name=Resource%20Name
```

# Responses

## Status Codes

**The following codes indicate success:**

**200** *OK* - Everything went according to plan, and the results are as documented.  
**304** *Not Modified* - No body returned. Used in conjunction with the ETag header (above)  

**The following codes indicate an error.** They return an error body vs. the documented body, for the following reasons

**400** *Bad Request* - The request fails a precondition and was rejected. Reason indicated in the body.  
**401** *Unauthorized* - Authorization header not supplied, or supplied with an invalid token.  
**404** *Not Found* - The resource requested by ID is not found in the system.  
**500** *Internal Server Error* - Oh crap - something bad happened on our end. You might find something useful in the response body.  
**501** *Not Implemented* - Coming soon to an API near you.  

## Response Headers

**content-encoding** - Supplied if the content was encoded, as requested by the `accept-encoding` request header.  
**content-length** - Byte count of the content body  
**content-type** - The content type response. Usually `appliction/json; charset-utf-8`  
**date** - The timestamp that the request arrived  
**etag** - A unique code representing the response. Used in conjunction with the `if-none-match` request header.  
**status** - The status code response  
**vary** - A value that may be useful for network caches  
**x-request-id** - A unique identifier for this request. If a request fails, this can be used to help trace the problem from server logs.  
**x-response-time** - The amount of time this request took for the server to process.  
**Access-Control-Allow-Origin** - Set to `*` to allow cross domain browser requests.  
**Access-Control-Allow-Headers** - Set to `Authorization, Cookie` to allow authorization.  
**Access-Control-Allow-Methods** - Set to `GET, POST, PUT, DELETE` to allow all API requests.  

## Response Body

On successful API call, the body is as documented. 

On unsuccessful API call (status code 400 or higher), the body contains error information.

# Users [/api/v2/users]
User - *An individual that interacts with the system*

## Read a user profile [GET /api/v2/users/{userId}]

Returns the profile for the specified user ID. 

+ Parameters
    + userId: `a3ec1321-cb6f-4957-bfc0-0b68d78caeba` (string, required) - The user resource id
+ Request
    + Headers

            Authorization: Basic ABCD-EFGH-IJKL-MNOP
+ Response 200 (application/json)
    + Attributes (User)

## Read user profiles [GET /api/v2/users]

Returns an array of user profiles. This will return a single user profile of the user making the request. It's useful if you have an Authorization token, but don't have the user ID.
+ Request
    + Headers

            Authorization: Basic ABCD-EFGH-IJKL-MNOP
+ Response 200 (application/json)
    + Attributes (Users)

## Update a user profile [PUT /api/v2/users/{userId}]

Updates your user profile. Most attributes can be updated, but not all. The `body` can contain 
a subset of attributes to update, or all attributes.

The resource /{userId} must be the ID associated with the Authentication token.

+ Parameters
    + userId: `a3ec1321-cb6f-4957-bfc0-0b68d78caeba` (string, required) - The user resource id
+ Attributes (User)
+ Request
    + Headers

            Authorization: Basic ABCD-EFGH-IJKL-MNOP
+ Response 200 (application/json)
    + Attributes (User)

## Delete a user [DELETE /api/v2/users/{userId}]

**Be very careful with this one.** If you delete yourself, that will be the last API call you're
able to make. You will be removed from all sites, and will have to be re-invited. Your user id and
API keys will be different, even if you're invited with the same email address.

The resource /{userId} must be the ID associated with the Authentication token.

+ Parameters
    + userId: `a3ec1321-cb6f-4957-bfc0-0b68d78caeba` (string, required) - The user resource id
+ Request
    + Headers

            Authorization: Basic ABCD-EFGH-IJKL-MNOP
+ Response 200

# Sites [/api/v2/sites]
Site - *A physical installation with managed devices.* All sites are associated with a *site server*,
also known as an *edge server*, responsible for managing devices, users, and security for the location.

## Read available sites [GET /api/v2/sites]

Returns all sites authorized for the user, as specified in the Authorization token.

This request is served without directly contacting the site servers.

+ Request
    + Headers

            Authorization: Basic ABCD-EFGH-IJKL-MNOP
+ Response 200 (application/json)
    + Attributes (array [Site Summary])

## Read site information [GET /api/v2/sites/{siteId}]

Returns site details for the user. This request is made to the site server.

+ Parameters
    + siteId: `a908` (string, required) - The ID of the site
+ Request
    + Headers

            Authorization: Basic ABCD-EFGH-IJKL-MNOP
+ Response 200 (application/json)
    + Attributes (Site)

## Leave a site [DELETE /api/v2/sites/{siteId}]

This requests the user specified by the Authorization token to leave the site.
Once a user has left a site, they must be invited back in.

+ Parameters
    + siteId: `a908` (string, required) - The ID of the site
+ Request
    + Headers

            Authorization: Basic ABCD-EFGH-IJKL-MNOP
+ Response 200

# Invitations [/api/v2/invites]
Invitation - *A request to invite a person to a site*. Sites are accessible by invite only.

## Send an invitation [POST /api/v2/invites]

Send an email invitation to join a site. This includes the security role for the individual 
and a custom message from the sender, so the recipient knows it didn't originate from a robot.

+ Attributes (Invite)
+ Request
    + Headers

            Authorization: Basic ABCD-EFGH-IJKL-MNOP
+ Response 200

# Data Structures

## User (object)
+ id: `3627cc99-d839-4684-bd78-8322703b273f` (string)
    The unique user identifier, used in subsequent PUT or DELETE calls.
+ firstName: `John` (string, required)
+ lastName: `Jones` (string)
+ email: `jjones84@gmail.com` (string, required)
+ mobile: `402 889-8765` (string)
+ avatarUrl: `https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50` (string)
    This starts out as a gravatar URL, and can be changed by uploading an avatar.

## Users (array [User])

## UserRole (enum[number])
+ `0` - Guest (custom authority)
+ `1` - Monitor (read only)
+ `2` - Controller (read and control)
+ `3` - Admin (administer site)
+ `4` - Owner (site owner)

## Site Summary (object)
+ id: `a908` (string)
    The unique identifier, to be used as siteId in site related API requests.
+ name: `Indoor Farm North` (string)
    Name given to the site by the site owner.

## Site (object)
+ id: `a908` (string)
    The unique identifier, to be used as siteId in site related API requests.
+ name: `Indoor Farm North` (string)
    Name given to the site by the site owner.
+ role (UserRole)
    The primary role (owner, admin, controller, monitor, guest)
+ menu (array [Menu Item])
    The list of menu items available for the requesting user.

## Menu Item (object)

+ id: `location-1` (string, required)
    A unique identifier across all menu items
+ name: `Clone Room` (string, required)
    The menu item display name
+ icon: `location` (string)
    An icon name as enumerated in the [ionicons](https://ionicframework.com/docs/ionicons/) page.
+ slug: `location` (string)
    Required for **webpage** type menu items. This is the unique URL slug for the web page.
+ url: `location` (string)
    Required for **webpage** type menu items. The URL to navigate to for this menu item.
+ hubId: `d8Je` (string)
    Required for **dashboard** type menu items. This is the site ID.
+ dashId: `clone-room` (string)
    Required for **dashboard** type menu items. This is the dashboard DB name.
+ page: `user-settings` (string)
    For *internal page* menu items. This directs to an internal page in the UI.
+ modalpage: `user-settings` (string)
    For *internal page* menu items. Same as above, only opens as a modal page vs. root page.
+ items (array [Menu Item], required)
    Array of menu sub-items if this item is a menu category. Zero length array if this is a leaf menu item.

## Invite (object)
+ id: `3627cc99-d839-4684-bd78-8322703b273f` (string)
    The unique invite identifier. Generated on the server.
+ siteId: `a908` (string, required)
    ID of the site being invited into.
+ role (UserRole, required)
    The security role of the user for this site.
+ email: `jjones84@gmail.com` (string, required)
    Email address of the invitee.
+ message: `Come see what we're doing here.` (string, required)
    Personal message to send to the person being invited.

