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
<@template.header "Broker List"/>

<script src="<@spring.url '/js/powerFilter.js'/>"></script>


<#setting number_format="0">
<div>
    <div id="kafdropVersion">${buildProperties.getVersion()} [${buildProperties.getTime()}]</div>

    <h2>数据总线集群概览</h2>
    <div id="cluster-overview">
        <table class="table table-bordered">
            <tbody>
            <tr>
                <td><i class="fa fa-server"></i>&nbsp;&nbsp;根服务器</td>
                <td>${bootstrapServers}</td>
            </tr>
            <tr>
                <td><i class="fa fa-database"></i>&nbsp;&nbsp;所有主题</td>
                <td>${clusterSummary.topicCount}</td>
            </tr>
            <tr>
                <td><i class="fa fa-pie-chart"></i>&nbsp;&nbsp;所有分区</td>
                <td>${clusterSummary.partitionCount}</td>
            </tr>
            <tr>
                <td><i class="fa fa-trophy"></i>&nbsp;&nbsp;首选领导分区总数</td>
                <td <#if clusterSummary.preferredReplicaPercent lt 1.0>class="warning"</#if>>${clusterSummary.preferredReplicaPercent?string.percent}</td>
            </tr>
            <tr>
                <td><i class="fa fa-heartbeat"></i>&nbsp;&nbsp;复制不足分区总数</td>
                <td <#if clusterSummary.underReplicatedCount gt 0>class="warning"</#if>>${clusterSummary.underReplicatedCount}</td>
            </tr>
            </tbody>
        </table>
    </div>

    <div id="brokers">
        <h3><i class="fa fa-server"></i> 消息服务</h3>
        <table class="table table-bordered">
            <thead>
            <tr>
                <th><i class="fa fa-tag"></i>&nbsp;&nbsp;ID</th>
                <th><i class="fa fa-laptop"></i>&nbsp;&nbsp;主机</th>
                <th><i class="fa fa-plug"></i>&nbsp;&nbsp;端口</th>
                <th><i class="fa fa-server"></i>&nbsp;&nbsp;机架</th>
                <th><i class="fa fa-trophy"></i>&nbsp;&nbsp;控制器</th>
                <th>
                    <i class="fa fa-pie-chart"></i>&nbsp;&nbsp;分区数量 (% of total)
                    <a title="# 该代理是分区的领导者"
                       data-toggle="tooltip" data-placement="top" href="#">
                        <i class="fa fa-question-circle"></i>
                    </a>
                </th>
            </tr>
            </thead>
            <tbody>
            <#if brokers?size == 0>
                <tr>
                    <td class="danger text-danger" colspan="8"><i class="fa fa-warning"></i> 无可用的Broker</td>
                </tr>
            <#elseif missingBrokerIds?size gt 0>
                <tr>
                    <td class="danger text-danger" colspan="8"><i class="fa fa-warning"></i> 错误的
                        brokers: <#list missingBrokerIds as b>${b}<#if b_has_next>, </#if></#list></td>
                </tr>
            </#if>
            <#list brokers as b>
                <tr>
                    <td><a href="<@spring.url '/broker/${b.id}'/>"><i class="fa fa-info-circle fa-lg"></i> ${b.id}</a></td>
                    <td>${b.host?if_exists}</td>
                    <td>${b.port?string}</td>
                    <td><#if b.rack??>${b.rack}<#else>-</#if></td>
                    <td><@template.yn b.controller/></td>
                    <td>${(clusterSummary.getBrokerLeaderPartitionCount(b.id))!0}
                        (${(clusterSummary.getBrokerLeaderPartitionRatio(b.id))?string.percent})
                    </td>
                </tr>
            </#list>
            </tbody>
        </table>
    </div>

    <div id="topics">
        <h3><i class="fa fa-database"></i> 主题&nbsp;&nbsp;&nbsp;<a href="<@spring.url '/acl'/>"><i class="fa fa-lock"></i> 访问控制</a></h3>
        <table class="table table-bordered">
            <thead>
            <tr>
                <th>
                    名称

                    <span style="font-weight:normal;">
                            &nbsp;<INPUT id='filter' size=25 NAME='searchRow' title='只需键入即可过滤行'>&nbsp;
                        <span id="rowCount"></span>
                    </span>
                </th>
                <th>
                    分区
                    <a title="主题中的分区数量"
                       data-toggle="tooltip" data-placement="top" href="#"
                    ><i class="fa fa-question-circle"></i></a>
                </th>
                <th>
                    % 首选
                    <a title="首选Broker被任命为领导者的分区的百分比"
                       data-toggle="tooltip" data-placement="top" href="#"
                    ><i class="fa fa-question-circle"></i></a>
                </th>
                <th>
                    # 复制不足
                    <a title="与主分区不同步的分区副本数"
                       data-toggle="tooltip" data-placement="top" href="#"
                    ><i class="fa fa-question-circle"></i></a>
                </th>
                <th>自定义</th>
            </tr>
            </thead>
            <tbody>
            <#if topics?size == 0>
                <tr>
                    <td colspan="5">无主题可用</td>
                </tr>
            </#if>
            <#list topics as t>
                <tr class="dataRow">
                    <td><a href="<@spring.url '/topic/${t.name}'/>">${t.name}</a></td>
                    <td>${t.partitions?size}</td>
                    <td <#if t.preferredReplicaPercent lt 1.0>class="warning"</#if>>${t.preferredReplicaPercent?string.percent}</td>
                    <td <#if t.underReplicatedPartitions?size gt 0>class="warning"</#if>>${t.underReplicatedPartitions?size}</td>
                    <td><@template.yn t.config?size gt 0/></td>
                </tr>
            </#list>
            </tbody>
        </table>
        <a class="btn btn-outline-light" href="<@spring.url '/topic/create'/>">
            <i class="fa fa-plus"></i> 新建主题
        </a>
    </div>
</div>

<@template.footer/>

<script>
    $(document).ready(function () {
        $('#filter').focus();

        <#if filter??>
        $('#filter').val('${filter}');
        </#if>
        $('[data-toggle="tooltip"]').tooltip()
    });
</script>
