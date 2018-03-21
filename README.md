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

**access-control-allow-origin** - Set to `*` to allow cross domain browser requests.  
**content-encoding** - Supplied if the content was encoded, as requested by the `accept-encoding` request header.  
**content-length** - Byte count of the content body  
**content-type** - The content type response. Usually `appliction/json; charset-utf-8`  
**date** - The timestamp that the request arrived  
**etag** - A unique code representing the response. Used in conjunction with the `if-none-match` request header.  
**status** - The status code response  
**vary** - A value that may be useful for network caches  
**x-request-id** - A unique identifier for this request. If a request fails, this can be used to help trace the problem from server logs.  
**x-response-time** - The amount of time this request took for the server to process.

## Response Body

On successful API call, the body is as documented. 

On unsuccessful API call (status code 400 or higher), the body contains error information.

# Users [/api/v2/users]
User - *An individual that interacts with the system*

## Read a user profile [GET /api/v2/users/{id}]

Returns the profile for the specified user ID. 

+ Parameters
    + id (string) - The user resource id
+ Response 200 (application/json)
    + Attributes (User)

## Read user profiles [GET /api/v2/users]

Returns an array of user profiles. This will return a single user profile of the user making the request. It's useful if you have an Authorization token, but don't have the user ID.
+ Response 200 (application/json)
    + Attributes (Users)


## Update a user profile [PUT /api/v2/users/{id}]

Updates your user profile. Most attributes can be updated, but not all. The `body` can contain 
a subset of attributes to update, or all attributes.

The resource /{id} must be the ID associated with the Authentication token.

+ Attributes (User)
+ Response 200 (application/json)
    + Attributes (User)

## Delete a user [DELETE /api/v2/users/{id}]

**Be really careful with this one.** If you delete yourself, that will be the last API call you're
able to make. You will be removed from all sites, and will have to be re-invited. Your user id and
API keys will be different, even if you're invited with the same email address.

The resource /{id} must be the ID associated with the Authentication token.

+ Response 200 (application/json)

# Data Structures

## User (object)
+ id: `3627cc99-d839-4684-bd78-8322703b273f` (string)
    The unique user identifier, used in subsequent PUT or DELETE calls.

+ firstName: `John` (string, required)
    First Name

+ lastName: `Jones` (string)

## Users (array [User])
