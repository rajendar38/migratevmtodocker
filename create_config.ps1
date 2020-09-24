# Parameter help description
Param(
     [Parameter(Mandatory = $false)]
     [String]$var
)


(Get-Content "c:\\JBoss\\jboss-eap-7.2\\bin\\standalone.conf.bat" ) | 
Foreach-Object {
     if ($_ -match ":JAVA_OPTS_SET") {
          #Add Lines before the selected pattern 
          "JAVA_OPTS=%JAVA_OPTS% -Dlog4j.configurationFile=spectrum-log4j.xml"

     }
     $_ # send the current line to output

} | Set-Content "c:\\JBoss\\jboss-eap-7.2\\bin\\standalone.conf.bat" 