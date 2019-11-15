firewall {
    all-ping enable
    broadcast-ping disable
    group {
        address-group EXT_DNS_GROUP {
            address 9.9.9.9
            address 8.8.8.8
            description "Public DNS Servers"
        }
        address-group HOME_GROUP {
            address 192.168.0.0/24
            description "Home Group"
        }
        address-group MULTIPLE_GROUP {
            address 192.168.1.0/24
            address 192.168.3.0/24
            description "Multiple Groups"
        }
        address-group OPENVPN_HOSTS {
            address 192.168.3.150
            description "Hosts behind OpenVPN"
        }
        address-group WIFI_GUEST_GROUP {
            address 192.168.3.0/24
            description "Wifi Guest Group"
        }
        address-group WIFI_IOT_GROUP {
            address 192.168.4.0/24
        }
    }
    ipv6-receive-redirects disable
    ipv6-src-route disable
    ip-src-route disable
    log-martians enable
    name HOME_IN {
        default-action drop
        rule 1 {
            action accept
            destination {
                address 192.168.0.10
                port 32400
            }
            protocol tcp
            source {
                group {
                    address-group WIFI_IOT_GROUP
                }
            }
        }
    }
    name HOME_OUT {
        default-action accept
        description "Home Out"
        rule 1 {
            action accept
            description "Allow Wifi Guest Replies"
            log disable
            protocol all
            source {
                group {
                    address-group WIFI_GUEST_GROUP
                }
            }
            state {
                established enable
                invalid disable
                new disable
                related enable
            }
        }
        rule 2 {
            action drop
            description "Drop Rest-Of Wifi Guest Traffic"
            log disable
            protocol all
            source {
                group {
                    address-group WIFI_GUEST_GROUP
                }
            }
        }
    }
    name WAN_IN {
        default-action drop
        description "WAN to internal"
        rule 10 {
            action accept
            description "Allow established/related"
            state {
                established enable
                related enable
            }
        }
        rule 20 {
            action drop
            description "Drop invalid state"
            state {
                invalid enable
            }
        }
        rule 30 {
            action drop
            description "Drop k8s api traffic"
            destination {
                port 6443
            }
            protocol tcp
            source {
                address !192.168.0.0/16
            }
        }
    }
    name WAN_LOCAL {
        default-action drop
        description "WAN to router"
        rule 10 {
            action accept
            description "Allow established/related"
            state {
                established enable
                related enable
            }
        }
        rule 20 {
            action drop
            description "Drop invalid state"
            state {
                invalid enable
            }
        }
        rule 30 {
            action accept
            description "Er-X SSH"
            destination {
                port 3000
            }
            protocol tcp
        }
    }
    name WIFI_GUEST_LOCAL {
        default-action drop
        description "Wifi Guest Local"
        rule 1 {
            action accept
            description "Allow DHCP"
            destination {
                port 67-68
            }
            log disable
            protocol udp
        }
        rule 2 {
            action accept
            description "Allow DNS"
            destination {
                port 53
            }
            log disable
            protocol tcp_udp
        }
        rule 3 {
            action accept
            description "Allow established/related"
            state {
                established enable
                related enable
            }
        }
    }
    name WIFI_IOT_LOCAL {
        default-action drop
        description "Wifi IOT Local"
        rule 1 {
            action accept
            description "Allow DHCP"
            destination {
                port 67-68
            }
            log disable
            protocol udp
        }
        rule 2 {
            action accept
            description "Allow DNS"
            destination {
                group {
                    address-group EXT_DNS_GROUP
                }
                port 53
            }
            log disable
            protocol tcp_udp
        }
        rule 3 {
            action accept
            description "Allow established/related"
            state {
                established enable
                related enable
            }
        }
    }
    receive-redirects disable
    send-redirects enable
    source-validation disable
    syn-cookies enable
}
interfaces {
    ethernet eth0 {
        description Internet
        dhcp-options {
            default-route no-update
            default-route-distance 20
            name-server no-update
        }
        duplex auto
        pppoe 0 {
            default-route none
            firewall {
                in {
                    name WAN_IN
                }
                local {
                    name WAN_LOCAL
                }
            }
            mtu 1492
            name-server none
            password U3Y2C6H6F3
            user-id 01761569050@bb.bonline.com
        }
        speed auto
    }
    ethernet eth1 {
        address 195.188.223.66/29
        description Local
        duplex auto
        firewall {
            in {
                name WAN_IN
            }
            local {
                name WAN_LOCAL
            }
        }
        speed auto
    }
    ethernet eth2 {
        description Local
        duplex auto
        speed auto
    }
    ethernet eth3 {
        description Local
        duplex auto
        speed auto
    }
    ethernet eth4 {
        description Local
        duplex auto
        poe {
            output pthru
        }
        speed auto
    }
    loopback lo {
    }
    switch switch0 {
        address 192.168.0.1/24
        description Local
        firewall {
            out {
                name HOME_OUT
            }
        }
        mtu 1500
        switch-port {
            interface eth2 {
            }
            interface eth3 {
            }
            interface eth4 {
            }
            vlan-aware disable
        }
        vif 3 {
            address 192.168.3.1/24
            description "Wifi Guest Net"
            firewall {
                local {
                    name WIFI_GUEST_LOCAL
                }
            }
            mtu 1500
        }
        vif 4 {
            address 192.168.4.1/24
            description "IOT Net"
            firewall {
                local {
                    name WIFI_IOT_LOCAL
                }
            }
            mtu 1500
        }
    }
}
port-forward {
    auto-firewall enable
    hairpin-nat enable
    lan-interface switch0
    lan-interface switch0.4
    lan-interface switch0.3
    rule 1 {
        description openshift
        forward-to {
            address 192.168.0.4
            port 8443
        }
        original-port 8443
        protocol tcp
    }
    rule 2 {
        description Plex
        forward-to {
            address 192.168.0.5
            port 32400
        }
        original-port 32400
        protocol tcp
    }
    rule 3 {
        description openshift-ingress
        forward-to {
            address 192.168.0.4
            port 443
        }
        original-port 443
        protocol tcp
    }
    rule 4 {
        description openshift-ingress-http
        forward-to {
            address 192.168.0.4
            port 80
        }
        original-port 80
        protocol tcp
    }
    rule 5 {
        description plex-pi
        forward-to {
            address 192.168.0.10
            port 32400
        }
        original-port 32410
        protocol tcp
    }
    rule 6 {
        description vhost-ssh
        forward-to {
            address 192.168.0.35
            port 22
        }
        original-port 3001
        protocol tcp
    }
    rule 7 {
        description k8s-api
        forward-to {
            address 192.168.0.6
            port 6443
        }
        original-port 6443
        protocol tcp
    }
    rule 8 {
        description osapps-plex
        forward-to {
            address 192.168.0.7
            port 32400
        }
        original-port 32411
        protocol tcp
    }
    wan-interface eth1
}
protocols {
    static {
        interface-route 0.0.0.0/0 {
            next-hop-interface pppoe0 {
                distance 50
            }
        }
        route 0.0.0.0/0 {
            next-hop 195.188.223.65 {
                distance 10
            }
        }
        route 192.168.100.1/32 {
            next-hop 195.188.223.65 {
            }
        }
    }
}
service {
    dhcp-server {
        disabled false
        hostfile-update enable
        shared-network-name IOT {
            authoritative enable
            subnet 192.168.4.0/24 {
                default-router 192.168.4.1
                dns-server 8.8.8.8
                dns-server 9.9.9.9
                domain-name iot.je.home
                lease 86400
                start 192.168.4.100 {
                    stop 192.168.4.149
                }
                static-mapping pi.iot.je.home {
                    ip-address 192.168.4.10
                    mac-address b8:27:eb:e7:08:f5
                }
                static-mapping ps3.iot.je.home {
                    ip-address 192.168.4.11
                    mac-address fc:0f:e6:62:e9:c9
                }
            }
        }
        shared-network-name WIFI_GUEST {
            authoritative enable
            subnet 192.168.3.0/24 {
                default-router 192.168.3.1
                dns-server 192.168.3.1
                domain-name guest.je.home
                lease 86400
                start 192.168.3.100 {
                    stop 192.168.3.149
                }
                static-mapping roku.je.home {
                    ip-address 192.168.3.150
                    mac-address d8:31:34:83:bf:fd
                }
            }
        }
        shared-network-name WIRED {
            authoritative disable
            subnet 192.168.0.0/24 {
                default-router 192.168.0.1
                dns-server 192.168.0.1
                domain-name je.home
                lease 86400
                start 192.168.0.20 {
                    stop 192.168.0.50
                }
                static-mapping emby.je.home {
                    ip-address 192.168.0.21
                    mac-address 52:54:00:3e:d1:da
                }
                static-mapping k8sdev.je.home {
                    ip-address 192.168.0.9
                    mac-address 52:54:00:72:9A:D9
                }
                static-mapping k8stest2.je.home {
                    ip-address 192.168.0.13
                    mac-address 52:54:00:92:be:7f
                }
                static-mapping k8stest3.je.home {
                    ip-address 192.168.0.15
                    mac-address 52:54:00:92:be:8f
                }
                static-mapping k8stesting.je.home {
                    ip-address 192.168.0.12
                    mac-address 52:54:00:92:be:6f
                }
                static-mapping k8s.je.home {
                    ip-address 192.168.0.6
                    mac-address 52:54:00:D4:9A:2E
                }
                static-mapping kproxy.je.home {
                    ip-address 192.168.0.16
                    mac-address 52:54:00:92:be:9f
                }
                static-mapping laptopw.je.home {
                    ip-address 192.168.0.30
                    mac-address b4:6b:fc:f5:11:3f
                }
                static-mapping laptop.je.home {
                    ip-address 192.168.0.31
                    mac-address 00:e0:4c:68:07:67
                }
                static-mapping openshift.je.home {
                    ip-address 192.168.0.5
                    mac-address 52:54:00:c0:7a:01
                }
                static-mapping oswg.je.home {
                    ip-address 192.168.0.8
                    mac-address 52:54:00:2a:01:3f
                }
                static-mapping os.je.home {
                    ip-address 192.168.0.7
                    mac-address 52:54:00:B1:12:CE
                }
                static-mapping pi2.je.home {
                    ip-address 192.168.0.11
                    mac-address b8:27:eb:81:65:2e
                }
                static-mapping pi4.je.home {
                    ip-address 192.168.0.14
                    mac-address dc:a6:32:0c:56:02
                }
                static-mapping picam.je.home {
                    ip-address 192.168.0.41
                    mac-address b8:27:eb:d8:e1:45
                }
                static-mapping pi.je.home {
                    ip-address 192.168.0.10
                    mac-address b8:27:eb:b2:5d:a0
                }
                static-mapping plex.je.home {
                    ip-address 192.168.0.20
                    mac-address 52:54:00:92:be:6c
                }
                static-mapping proxy.je.home {
                    ip-address 192.168.0.4
                    mac-address 52:54:00:23:55:3d
                }
                static-mapping tplinksw.je.home {
                    ip-address 192.168.0.249
                    mac-address f0:9f:c2:61:85:84
                }
                static-mapping tpswitch.je.home {
                    ip-address 192.168.0.249
                    mac-address E8:DE:27:41:AF:BF
                }
                static-mapping unifiap.je.home {
                    ip-address 192.168.0.2
                    mac-address f0:9f:c2:f3:ca:2f
                }
                static-mapping wgproxy.je.home {
                    ip-address 192.168.0.49
                    mac-address 52:54:00:de:8e:97
                }
            }
        }
        static-arp disable
        use-dnsmasq disable
    }
    dns {
        forwarding {
            cache-size 150
            listen-on switch0
            listen-on switch0.3
            listen-on switch0.4
            name-server 9.9.9.9
            name-server 8.8.8.8
            options server=/je.home/192.168.0.1
            options server=/0.168.192.in-addr.arpa/192.168.0.1
            options address=/apps.letitbleed.org/192.168.0.4
            options address=/osapps.letitbleed.org/192.168.0.4
            options address=/k8s.letitbleed.org/192.168.0.4
            options address=/k8stesting.je.home/192.168.0.12
            options address=/k8stest2.je.home/192.168.0.13
            options address=/k8stest3.je.home/192.168.0.15
            system
        }
    }
    gui {
        ca-file /config/ssl/ca.pem
        cert-file /config/ssl/server.pem
        http-port 80
        https-port 443
        older-ciphers enable
    }
    lldp {
    }
    nat {
        rule 10 {
            description "Er-X SSH"
            destination {
                address 192.168.0.1
                port 22
            }
            inbound-interface switch0
            inside-address {
                address 192.168.0.1
                port 3000
            }
            protocol tcp
            type destination
        }
        rule 5009 {
            description "masquerade for eth1"
            outbound-interface eth1
            type masquerade
        }
        rule 5010 {
            description "masquerade for WAN"
            outbound-interface pppoe0
            type masquerade
        }
        rule 5011 {
            description "masq for openvpn"
            outbound-interface vtun0
            type masquerade
        }
    }
    ssh {
        listen-address 192.168.0.1
        port 3000
        protocol-version v2
    }
    unms {
        disable
    }
}
system {
    config-management {
        commit-revisions 10
    }
    domain-name erx.je.home
    host-name er.je.home
    ip {
        override-hostname-ip 192.168.0.1
    }
    login {
        user ubnt {
            authentication {
                encrypted-password $6$MxD3K0Iju$B85ouJeUsqSL4VABrd7d.zZgiDje8ePsr2L7/OsQ7JGHoUgbTyLS0f.q/qSzrbh6R.nOetdFAsuxcmo5o8rN10
                public-keys james.eckersall@jameseck-laptop.glo.gb {
                    key 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
                    type ssh-rsa
                }
            }
            level admin
        }
    }
    name-server 127.0.0.1
    ntp {
        server 0.ubnt.pool.ntp.org {
        }
        server 1.ubnt.pool.ntp.org {
        }
        server 2.ubnt.pool.ntp.org {
        }
        server 3.ubnt.pool.ntp.org {
        }
    }
    offload {
        hwnat enable
    }
    static-host-mapping {
        host-name emby.je.home {
            inet 192.168.0.21
        }
        host-name er.je.home {
            inet 192.168.0.1
        }
        host-name k8sdev.je.home {
            inet 192.168.0.9
        }
        host-name k8stest2.je.home {
            inet 192.168.0.13
        }
        host-name k8stest3.je.home {
            inet 192.168.0.15
        }
        host-name k8stesting.je.home {
            inet 192.168.0.12
        }
        host-name k8s.je.home {
            inet 192.168.0.6
        }
        host-name kproxy.je.home {
            inet 192.168.0.16
        }
        host-name laptopw.je.home {
            inet 192.168.0.30
        }
        host-name laptop.je.home {
            inet 192.168.0.31
        }
        host-name openshift.je.home {
            inet 192.168.0.5
        }
        host-name oswg.je.home {
            inet 192.168.0.8
        }
        host-name os.je.home {
            inet 192.168.0.7
        }
        host-name pi2.je.home {
            inet 192.168.0.11
        }
        host-name picam.je.home {
            inet 192.168.0.41
        }
        host-name pi.iot.je.home {
            inet 192.168.4.10
        }
        host-name pi.je.home {
            inet 192.168.0.10
        }
        host-name plex.je.home {
            inet 192.168.0.20
        }
        host-name proxy.je.home {
            inet 192.168.0.4
        }
        host-name ps3.iot.je.home {
            inet 192.168.4.11
        }
        host-name roku.je.home {
            inet 192.168.3.150
        }
        host-name tplinksw.je.home {
            inet 192.168.0.249
        }
        host-name tpswitch.je.home {
            inet 192.168.0.249
        }
        host-name unifiap.je.home {
            inet 192.168.0.2
        }
        host-name vhost.je.home {
            inet 192.168.0.35
        }
        host-name wgproxy.je.home {
            inet 192.168.0.49
        }
    }
    syslog {
        global {
            facility all {
                level notice
            }
            facility protocols {
                level debug
            }
        }
    }
    time-zone UTC
}


/* Warning: Do not remove the following line. */
/* === vyatta-config-version: "config-management@1:conntrack@1:cron@1:dhcp-relay@1:dhcp-server@4:firewall@5:ipsec@5:nat@3:qos@1:quagga@2:suspend@1:system@4:ubnt-pptp@1:ubnt-udapi-server@1:ubnt-unms@1:ubnt-util@1:vrrp@1:webgui@1:webproxy@1:zone-policy@1" === */
/* Release version: v1.10.10.5210345.190714.1127 */
