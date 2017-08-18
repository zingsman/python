#!/usr/bin/python
import sys
a=sys.argv[1]
b=sys.argv[2]
print(a)
print(b)
news = '''\
<?xml version="1.0" encoding="UTF-8"?>
<zabbix_export>
    <version>3.0</version>
    <date>2017-08-11T07:55:08Z</date>
    <groups>
        <group>
            <name>Linux servers</name>
        </group>
    </groups>
    <hosts>
        <host>
            <host>10.253.2.51</host>
            <name>7牛appserver （ 10.253.2.51）-孙耀</name>
            <description/>
            <proxy/>
            <status>0</status>
            <ipmi_authtype>-1</ipmi_authtype>
            <ipmi_privilege>2</ipmi_privilege>
            <ipmi_username/>
            <ipmi_password/>
            <tls_connect>1</tls_connect>
            <tls_accept>1</tls_accept>
            <tls_issuer/>
            <tls_subject/>
            <tls_psk_identity/>
            <tls_psk/>
            <templates>
                <template>
                    <name>Linux-Templates</name>
                </template>
            </templates>
            <groups>
                <group>
                    <name>Linux servers</name>
                </group>
            </groups>
            <interfaces>
                <interface>
                    <default>1</default>
                    <type>1</type>
                    <useip>1</useip>
                    <ip>10.253.2.51</ip>
                    <dns/>
                    <port>10050</port>
                    <bulk>1</bulk>
                    <interface_ref>if1</interface_ref>
                </interface>
            </interfaces>
            <applications/>
            <items/>
            <discovery_rules/>
            <macros/>
            <inventory/>
        </host>
    </hosts>
</zabbix_export>
'''

print(news)