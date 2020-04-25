<#--
 Copyright 2016 Kafdrop contributors.

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
<@template.header "Broker: ${broker.id?string}">
    <style type="text/css">
        .bs-table.overview td {
            white-space: nowrap;
        }

        td.leader-partitions {
            word-break: break-all;
        }
    </style>
</@template.header>

<#setting number_format="0">

<h2>服务ID: ${broker.id}</h2>

<div id="topic-overview">
    <h3>服务概览</h3>

    <table class="table table-bordered overview">
        <tbody>
        <tr>
            <td><i class="fa fa-laptop"></i>&nbsp;&nbsp;主机</td>
            <td>${broker.host?if_exists}</td>
        </tr>
        <tr>
            <td><i class="fa fa-plug"></i>&nbsp;&nbsp;端口</td>
            <td>${broker.port}</td>
        </tr>
        <tr>
            <td><i class="fa fa-server"></i>&nbsp;&nbsp;机架</td>
            <td><#if broker.rack??>${broker.rack}<#else>-</#if></td>
        </tr>
        <tr>
            <td><i class="fa fa-trophy"></i>&nbsp;&nbsp;控制器</td>
            <td><@template.yn broker.controller/></td>
        </tr>
        <tr>
            <td><i class="fa fa-database"></i>&nbsp;&nbsp;主题数量</td>
            <td>${topics?size}</td>
        </tr>

        <#assign partitionCount=0>
        <#list topics as t>
            <#assign partitionCount=partitionCount+(t.getLeaderPartitions(broker.id)?size)>
        </#list>
        <tr>
            <td><i class="fa fa-pie-chart"></i>&nbsp;&nbsp;分区数量</td>
            <td>${partitionCount}</td>
        </tr>
        </tbody>
    </table>
</div>

<div>
    <h3>主题详情</h3>

    <table class="table table-bordered">
        <thead>
        <tr>
            <th>主题</th>
            <th>总分区</th>
            <th>服务分区</th>
            <th>分区IDs</th>
        </tr>
        </thead>
        <tbody>
        <#list topics as t>
            <tr>
                <td><a href="<@spring.url '/topic/${t.name}'/>">${t.name}</a></td>
                <td>${t.partitions?size}</td>
                <td>${t.getLeaderPartitions(broker.id)?size}</td>
                <td class="leader-partitions"><#list t.getLeaderPartitions(broker.id) as p>${p.id}<#sep>,</#list></td>
            </tr>
        </#list>
        </tbody>
    </table>
</div>

<@template.footer/>
