# Nextcloud Talk Recording Server API

* API v1: Base endpoint `/api/v1`

## Get welcome message

* Method: `GET`
* Endpoint: `/welcome`

* Response:
    - Status code:
        + `200 OK`

## Requests from the Nextcloud server

* Method: `POST`
* Endpoint: `/room/{token}`

* Header:

| field                     | type   | Description                                                                                                                         |
| ------------------------- | ------ | ----------------------------------------------------------------------------------------------------------------------------------- |
| `TALK_RECORDING_BACKEND`  | string | The base URL of the Nextcloud server sending the request.                                                                           |
| `TALK_RECORDING_RANDOM`   | string | Random string that needs to be concatenated with request body to generate the checksum using the secret configured for the backend. |
| `TALK_RECORDING_CHECKSUM` | string | The checksum generated with `TALK_RECORDING_RANDOM`.                                                                                |

* Response:
    - Status code:
        + `200 OK`
        + `400 Bad Request`: When the body size exceeds the maximum allowed message size.
        + `400 Bad Request`: When the body data does not match the expected format.
        + `403 Forbidden`: When the request validation failed.

### Start call recording

* Data format (JSON):

    ```json
    {
      "type": "start",
      "start": {
        "status": "the-type-of-recording (1 for audio and video, 2 for audio only)",
        "owner": "the-user-to-upload-the-resulting-file-as",
      }
    }
    ```

### Stop call recording

* Data format:

    ```json
    {
      "type": "stop",
    }
    ```
