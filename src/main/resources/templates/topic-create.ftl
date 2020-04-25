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
<@template.header "创建主题"/>

<script src="<@spring.url '/js/powerFilter.js'/>"></script>


<#setting number_format="0">
<div>
    <h2>主题创建</h2>
    <a class="btn btn-outline-light" href="<@spring.url '/'/>">
        回退
    </a>
    <div id="create-form">
        <form action="<@spring.url '/topic'/>" method="POST">
            <table class="table table-bordered" style="width: 40%; margin-top: 20px">
                <tbody>
                <tr>
                    <td>主题名称</td>
                    <td align="center"><input type="text" name="name" required></td>
                </tr>
                <tr>
                    <td>分区数量</td>
                    <td align="center"><input type="number" name="partitionsNumber" value="1" required></td>
                </tr>
                <tr>
                    <td>复制因子</td>
                    <td align="center"><input type="number" name="replicationFactor" value="${brokersCount}" required></td>
                </tr>
                </tbody>
            </table>
            <button class="btn btn-success" type="submit">
                <i class="fa fa-plus"></i> 创建
            </button>
            <br>
            <br>
            <#if errorMessage??>
                <p>创建主题错误 ${topicName}: ${errorMessage}</p>
            <#elseif topicName??>
                <p>成功创建主题 <a href="<@spring.url '/topic/${topicName}'/>">${topicName}</a> </p>
            </#if>
        </form>
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
