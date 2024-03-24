function FindProxyForURL(url, host) { 
// If the requested website is hosted within the internal network, send direct.
    if (isPlainHostName(host) || 
        isInNet((host), "10.0.0.0", "255.0.0.0") ||
        isInNet((host), "172.16.0.0", "255.240.0.0") ||
        isInNet((host), "192.168.0.0", "255.255.0.0") ||
	isInNet((host), "127.0.0.0", "255.255.255.0")) 
        return "DIRECT";

    if (isPlainHostName(host) || 
        shExpMatch(host, "*.local") || 
        isInNet(dnsResolve(host), "10.0.0.0", "255.0.0.0") || 
        isInNet(dnsResolve(host), "172.16.0.0", "255.240.0.0") || 
        isInNet(dnsResolve(host), "192.168.0.0", "255.255.0.0") || 
        isInNet(dnsResolve(host), "127.0.0.0", "255.255.255.0")) 
        return "DIRECT"; 

// DEFAULT RULE: All other traffic, use below proxies, in fail-over order. 
    return "PROXY 127.0.0.1:1090;" 
}
