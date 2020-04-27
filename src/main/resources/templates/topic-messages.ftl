<#--
 Copyright 2019 Kafdrop contributors.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->
<#import "/spring.ftl" as spring />
<#import "lib/template.ftl" as template>

<@template.header "主题: ${topic.name}: 消息">
    <style type="text/css">
        h2 {
            margin-bottom: 16px;
        }
        .badge {
            margin-right: 5px;
        }
        .toggle-msg {
            float: left;
        }
    </style>
    <script src="<@spring.url '/js/message-inspector.js'/>"></script>
</@template.header>
<#setting number_format="0">

<h2>主题: <a href="<@spring.url '/topic/${topic.name}'/>">${topic.name}</a></h2>

<div class="container">
    <#if messages?? && messages?size gt 0>
        <#list messages as msg>
            <div class="message-detail">
                <span class="badge badge-light">分区:</span> ${msg.partition} &nbsp;
                <span class="badge badge-light">位移:</span> ${msg.offset} &nbsp;
                <span class="badge badge-light">键:</span> ${msg.key!''} &nbsp;
                <span class="badge badge-light">时间戳:</span> ${msg.timestamp?string('yyyy-MM-dd HH:mm:ss.SSS')}
                <span class="badge badge-light">头:</span> ${msg.headersFormatted}
                <div>
                    <a href="#" class="toggle-msg"><i class="fa fa-chevron-circle-right">&nbsp;</i></a>
                    <pre class="message-body">${msg.message!''}</pre>
                </div>
            </div>
        </#list>

    </#if>
</div>

<@template.footer/>
