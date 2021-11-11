package com.example.demo;/*
 * Copyright 2021 The Playce-WASUP Project.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Revision History
 * Author            Date                Description
 * ---------------  ----------------    ------------
 * Hoon Oh       11월 10, 2021            First Draft.
 */

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

/**
 * <pre>
 *
 *
 * </pre>
 *
 * @author Hoon Oh
 * @version 1.0
 */
@Component
@ConfigurationProperties(prefix = "log")
public class LogLevel {

    private String level;

    public String getLevel(){
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }
}
//end of LogLevel.java