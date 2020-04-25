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
<@template.header "主题: ${topic.name}">
    <style type="text/css">
        #action-bar {
            margin-top: 17px;
        }

        th {
            word-break: break-all;
        }

        #delete-topic-form {
            display: inline-block;
            float: right;
        }
    </style>
</@template.header>

<#setting number_format="0">

<h2>主题: ${topic.name}</h2>

<#if deleteErrorMessage??>
    <p>删除主题时出错 ${topic.name}: ${deleteErrorMessage}</p>
</#if>

<div id="action-bar" class="container pl-0">
    <a id="topic-messages" class="btn btn-outline-light" href="<@spring.url '/topic/${topic.name}/messages'/>"><i class="fa fa-eye"></i> 查阅消息</a>
    <form id="delete-topic-form" action="<@spring.url '/topic/${topic.name}/delete'/>" method="POST">
        <button class="btn btn-danger" type="submit"><i class="fa fa-remove"></i> 删除主题</button>
    </form>
</div>
<br/>
<div class="container-fluid pl-0">
    <div class="row">
        <div id="topic-overview" class="col-md-8">
            <h3>概览</h3>

            <table class="table table-bordered">
                <tbody>
                <tr>
                    <td># 分区</td>
                    <td>${topic.partitions?size}</td>
                </tr>
                <tr>
                    <td>首选副本</td>
                    <td <#if topic.preferredReplicaPercent lt 1.0>class="warning"</#if>>${topic.preferredReplicaPercent?string.percent}</td>
                </tr>
                <tr>
                    <td>复制不足的分区</td>
                    <td <#if topic.underReplicatedPartitions?size gt 0>class="warning"</#if>>${topic.underReplicatedPartitions?size}</td>
                </tr>
                <tr>
                    <td>总大小</td>
                    <td>${topic.totalSize}</td>
                </tr>
                <tr>
                    <td>总可用消息</td>
                    <td>${topic.availableSize}</td>
                </tr>
                </tbody>
            </table>
        </div>

        <div id="topic-config" class="col-md-4">
            <h3>配置</h3>

            <#if topic.config?size == 0>
                <div>没有特定主题的配置</div>
            <#else>
                <table class="table table-bordered">
                    <tbody>
                    <#list topic.config?keys as c>
                        <tr>
                            <td>${c}</td>
                            <td>${topic.config[c]}</td>
                        </tr>
                    </#list>
                    </tbody>
                </table>
            </#if>
        </div>

    </div>

    <div class="row">
        <div id="partition-detail" class="col-md-8">
            <h3>分区详情</h3>
            <table id="partition-detail-table" class="table table-bordered table-sm small">
                <thead>
                <tr>
                    <th>分区</th>
                    <th>第一<br>偏移</th>
                    <th>最后<br>偏移</th>
                    <th>尺寸</th>
                    <th>领导<br>节点</th>
                    <th>复制<br>节点</th>
                    <th>同步中<br>复制<<br>节点</th>
                    <th>离线<br>复制<br>节点</th>
                    <th>首选<br>领导</th>
                    <th>复制不足</th>
                </tr>
                </thead>
                <tbody>
                <#list topic.partitions as p>
                    <tr>
                        <td><a href="<@spring.url '/topic/${topic.name}/messages?partition=${p.id}&offset=${p.firstOffset}&count=100'/>">${p.id}</a></td>
                        <td>${p.firstOffset}</td>
                        <td>${p.size}</td>
                        <td>${p.size - p.firstOffset}</td>
                        <td <#if !(p.leader)??>class="warning"</#if>>${(p.leader.id)!"none"}</td>
                        <td><#list p.replicas as r>${r.id}<#if r_has_next>,</#if></#list></td>
                        <td><#list p.inSyncReplicas as r>${r.id}<#if r_has_next>,</#if></#list></td>
                        <td><#list p.offlineReplicas as r>${r.id}<#if r_has_next>,</#if></#list></td>
                        <td <#if !p.leaderPreferred>class="warning"</#if>><@template.yn p.leaderPreferred/></td>
                        <td <#if p.underReplicated>class="warning"</#if>><@template.yn p.underReplicated/></td>
                    </tr>
                </#list>
                </tbody>
            </table>
        </div>

        <div id="consumers" class="col-md-4">
            <h3>消费者</h3>
            <table id="consumers-table" class="table table-bordered table-sm small">
                <thead>
                <tr>
                    <th>组 ID</th>
                    <th>合并滞后</th>
                </tr>
                </thead>
                <tbody>
                <#list consumers![] as c>
                    <tr>
                        <td><a href="<@spring.url '/consumer/${c.groupId}'/>">${c.groupId}</a></td>
                        <td>${c.getTopic(topic.name).lag}</td>
                    </tr>
                </#list>
                </tbody>
            </table>
        </div>
    </div>
</div>
<@template.footer/>

<script>
  $(document).ready(function () {
    let removalConfirmed = false;

    $('#delete-topic-form').submit(function (event) {
      if (!removalConfirmed) {
        event.preventDefault();
        if(confirm('您确定要删除主题?')) {
          removalConfirmed = true;
          $('#delete-topic-form').submit();
        }
      }
    });
  });
</script>
