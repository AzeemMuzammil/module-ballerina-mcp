// Copyright (c) 2025 WSO2 LLC (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

# Processes a server response and extracts the result.
#
# + serverResponse - The response from the server, which may be a single JsonRpcMessage, a stream, or a transport error.
# + return - Extracted ServerResult, ServerResponseError, or StreamError.
isolated function processServerResponse(JsonRpcMessage|stream<JsonRpcMessage, StreamError?>|StreamableHttpTransportError? serverResponse)
        returns ServerResult|ServerResponseError|StreamError {

    if serverResponse is stream<JsonRpcMessage, StreamError?> {
        return extractResultFromMessageStream(serverResponse);
    }

    if serverResponse is JsonRpcMessage {
        return extractResultFromMessage(serverResponse);
    }

    if serverResponse is () {
        return error MalformedResponseError("Received null response from server.");
    }

    return error ServerResponseError(
        string `Transport error connecting to server: ${serverResponse.message()}`
    );
}

# Extracts the first valid result from a stream of JsonRpcMessages.
#
# + messageStream - The stream of JsonRpcMessages to process.
# + return - The first valid ServerResult, a specific ServerResponseError, or StreamError.
isolated function extractResultFromMessageStream(stream<JsonRpcMessage, StreamError?> messageStream)
        returns ServerResult|ServerResponseError|StreamError {

    record {|JsonRpcMessage value;|}|StreamError? streamItem = messageStream.next();
    // Iterate until a valid result or an error is found.
    while streamItem !is () {
        if streamItem is StreamError {
            return streamItem;
        }

        JsonRpcMessage message = streamItem.value;
        if message is JsonRpcResponse {
            return message.result;
        }
        streamItem = messageStream.next();
    }

    return error InvalidMessageTypeError("No valid messages found in server message stream.");
}

# Extracts the result from a JsonRpcMessage and converts it to a ServerResult.
#
# + message - The JsonRpcMessage to convert.
# + return - The extracted ServerResult, or an InvalidMessageTypeError.
isolated function extractResultFromMessage(JsonRpcMessage message) returns ServerResult|ServerResponseError {
    if message is JsonRpcResponse {
        return message.result;
    }
    return error InvalidMessageTypeError("Received message from server is not a valid JsonRpcResponse.");
}

# Retrieves the service configuration from an MCP service.
#
# + mcpService - The MCP service instance
# + return - The service configuration
isolated function getServiceConfiguration(Service|AdvancedService mcpService) returns ServiceConfiguration {
    typedesc mcpServiceType = typeof mcpService;
    ServiceConfiguration? serviceConfig = mcpServiceType.@ServiceConfig;
    return serviceConfig ?: {
        info: {
            name: "MCP Service",
            version: "1.0.0"
        }
    };
}
