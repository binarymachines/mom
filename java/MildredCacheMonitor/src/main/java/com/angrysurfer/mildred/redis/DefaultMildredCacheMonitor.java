package com.angrysurfer.mildred.redis;

public class DefaultMildredCacheMonitor implements IMildredCacheMonitor {

    public void onUnsubscribe(String channel, int subscribedChannels) { }

    public void onSubscribe(String channel, int subscribedChannels) { }

    public void onPUnsubscribe(String pattern, int subscribedChannels) { }

    public void onPSubscribe(String pattern, int subscribedChannels) { }

    public void onPMessage(String pattern, String channel, String message) { }

    public void onMessage(String channel, String message) { }
}
