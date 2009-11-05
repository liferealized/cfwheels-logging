<cfcomponent>

	<cffunction name="init" output="false" access="public" returntype="any">
		<cfset this.version = "1.0" />
		<cfreturn this />
	</cffunction>
	
	<cffunction name="logger" access="public" returntype="void" mixin="global">
		<cfargument name="output" type="string" required="true" />
		<cfargument name="folder" type="string" required="false" default="/logs" />
		<cfargument name="extension" type="string" required="false" default="txt" />
		<cfargument name="environment" type="string" required="false" default="#application.wheels.environment#" />
		<cfscript>
			var loc = { 
				  dateStamp = DateFormat(Now(), "yyyy-mm-dd")
				, timeStamp = TimeFormat(Now(), "HH:mm:ss:l")
				, relativeFolder = ListAppend(arguments.folder, arguments.environment, "/")
				, absoluteFolder = ExpandPath(loc.relativeFolder)
				, relativeFile =  ListAppend(loc.relativeFolder, ListAppend(loc.dateStamp, arguments.extension, "."), "/")
				, absoluteFile = ExpandPath(loc.relativeFile)
			};
		</cfscript>
			
		<!--- spin off a new thread so logging isn't holding us up --->
		<cfthread action="run" name="logging" arguments="#arguments#" loc="#loc#">
		
			<cfif not DirectoryExists(attributes.loc.absoluteFolder)>
				<cfdirectory action="create" directory="#attributes.loc.absoluteFolder#" mode="755" />
			</cfif>
			
			<cfif not FileExists(attributes.loc.absoluteFile)>
				<cffile action="write" file="#attributes.loc.absoluteFile#" output="" />
			</cfif>
			
			<cffile action="append" file="#attributes.loc.absoluteFile#" output="#attributes.loc.dateStamp# #attributes.loc.timeStamp# #attributes.arguments.output#" />
		</cfthread>
		
		<!--- return nothing --->
		<cfreturn  />
	</cffunction>

</cfcomponent>
