    sed -e "s#<construct class=\"org.sourceid.oauth20.domain.ClientManagerXmlFileImpl\"/>#<construct class=\"org.sourceid.oauth20.domain.ClientManagerLdapImpl\"/>#" \
        -e "s#<create-instance class=\"org.sourceid.oauth20.token.AccessGrantManagerJdbcImpl\"/>#<create-instance class=\"org.sourceid.oauth20.token.AccessGrantManagerLDAPPingDirectoryImpl\"/>#" \
        "/opt/out/instance/server/default/conf/META-INF/hivemodule.xml" > "/opt/out/instance/server/default/conf/META-INF/hivemodule.xml-modified"
