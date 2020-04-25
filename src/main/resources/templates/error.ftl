<#import "/spring.ftl" as spring />
<#import "lib/template.ftl" as template>
<@template.header "${error.error}"/>
<h2>${error.error}</h2>
<div id="errorHeader">
A ${error.status} 错误发生: <span id="errorMessage">${error.message}</span>
</div>
<#if error.trace??>
    <div id="stackTraceTitle">堆栈追踪</div>
    <div id="stackTrace">
    ${error.trace}
    </div>
<#else>
</#if>
<@template.footer/>
