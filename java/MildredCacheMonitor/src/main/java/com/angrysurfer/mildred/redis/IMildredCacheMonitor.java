package com.angrysurfer.mildred.redis;

/**
 * Created by mpippins on 12/13/16.
 */
public interface IMildredCacheMonitor {

    public void onUnsubscribe(String channel, int subscribedChannels);

    public void onSubscribe(String channel, int subscribedChannels);

    public void onPUnsubscribe(String pattern, int subscribedChannels);

    public void onPSubscribe(String pattern, int subscribedChannels);

    public void onMessage(String channel, String message);

}
