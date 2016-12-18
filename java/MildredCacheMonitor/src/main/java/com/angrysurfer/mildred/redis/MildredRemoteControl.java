package com.angrysurfer.mildred.redis;

/**
 * Created by mpippins on 12/17/16.
 */
public class MildredRemoteControl {

    private String redisHost;
    private int redisPort;

    public MildredRemoteControl(String host, int port) {

        this.redisHost = host;
        this.redisPort = port;
    }

    public void reconfigure() {

    }

    public void shutDown() {

    }

    public void stop() {

    }

}
