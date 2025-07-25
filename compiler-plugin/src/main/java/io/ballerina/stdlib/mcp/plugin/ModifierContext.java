/*
 * Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
 *
 * WSO2 LLC. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.mcp.plugin;

import io.ballerina.compiler.syntax.tree.FunctionDefinitionNode;

import java.util.HashMap;
import java.util.Map;

public class ModifierContext {
    private final Map<FunctionDefinitionNode, ToolAnnotationConfig> annotationConfigMap = new HashMap<>();

    void add(FunctionDefinitionNode node, ToolAnnotationConfig config) {
        annotationConfigMap.put(node, config);
    }

    Map<FunctionDefinitionNode, ToolAnnotationConfig> getAnnotationConfigMap() {
        return annotationConfigMap;
    }
}

record ToolAnnotationConfig(
        String description,
        String schema) {

    public static final String DESCRIPTION_FIELD_NAME = "description";
    public static final String SCHEMA_FIELD_NAME = "schema";

    public String get(String field) {
        return switch (field) {
            case DESCRIPTION_FIELD_NAME -> description();
            case SCHEMA_FIELD_NAME -> schema();
            default -> null;
        };
    }
}
