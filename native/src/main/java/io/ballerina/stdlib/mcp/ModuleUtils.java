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

package io.ballerina.stdlib.mcp;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.Module;
import io.ballerina.runtime.api.creators.ErrorCreator;
import io.ballerina.runtime.api.values.BError;

import static io.ballerina.runtime.api.utils.StringUtils.fromString;

public final class ModuleUtils {
    private static Module module;

    private ModuleUtils() {
    }

    @SuppressWarnings("unused")
    public static Module getModule() {
        return module;
    }

    @SuppressWarnings("unused")
    public static void setModule(Environment env) {
        module = env.getCurrentModule();
    }

    public static BError createError(String errorMessage) {
        return ErrorCreator.createError(fromString(errorMessage));
    }
}
