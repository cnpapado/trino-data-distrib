package com.mycompany;

import org.apache.zookeeper.ZooKeeper;

public class SimpleZKTest {
    public static void main(String[] args) throws Exception {
        System.setProperty("java.net.preferIPv4Stack", "true");
        java.security.Security.setProperty("networkaddress.cache.ttl", "0");
        java.security.Security.setProperty("networkaddress.cache.negative.ttl", "0");

        System.out.println("Hellooo");


        ZooKeeper zk = new ZooKeeper("127.0.0.1:2181", 3000, null);
        System.out.println("ZooKeeper state: " + zk.getState());
        zk.close();
    }
}
