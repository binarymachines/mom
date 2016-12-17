package com.angrysurfer.mildred.redis;


import redis.clients.jedis.Jedis;
import redis.clients.jedis.JedisPubSub;

public class MildredCachePubSub extends JedisPubSub {

    private IMildredCacheMonitor _monitor;

    public MildredCachePubSub(IMildredCacheMonitor monitor) {
        _monitor = monitor;
    }

    @Override
    public void onUnsubscribe(String channel, int subscribedChannels) {

    }

    @Override
    public void onSubscribe(String channel, int subscribedChannels) {

    }

    @Override
    public void onPUnsubscribe(String pattern, int subscribedChannels) {
    }

    @Override
    public void onPSubscribe(String pattern, int subscribedChannels) {
    }

    @Override
    public void onPMessage(String pattern, String channel, String message) {
    }

    @Override
    public void onMessage(String channel, String message) {

        _monitor.onMessage(channel, message);
    }

    public void addSubscription(final String redisHost, final String channel) throws Exception {
        final MildredCachePubSub pubsub = this;

        new Thread(new Runnable() {

            public void run() {
               Jedis jedis = new Jedis(redisHost);

                jedis.subscribe(pubsub, channel);

                jedis.quit();

            }
        }, channel + "SubscriberThread").start();

    }

    static final long startMillis = System.currentTimeMillis();

    private static void log(String string, Object... args) {
        long millisSinceStart = System.currentTimeMillis() - startMillis;
        System.out.printf("%20s %6d %s\n", Thread.currentThread().getName(), millisSinceStart,
                String.format(string, args));
    }

    public static void main(String[] args) {

        MildredCachePubSub mcps = new MildredCachePubSub(new IMildredCacheMonitor() {
            public void onUnsubscribe(String channel, int subscribedChannels) {


            }

            public void onSubscribe(String channel, int subscribedChannels) {

            }

            public void onPUnsubscribe(String pattern, int subscribedChannels) {

            }

            public void onPSubscribe(String pattern, int subscribedChannels) {

            }

            public void onMessage(String channel, String message) {

                log(channel.concat(": ").concat(message));
            }

        });

        try {
            mcps.addSubscription("localhost", "operator");
            mcps.addSubscription("localhost", "operation");
            mcps.addSubscription("localhost", "target");
        }
        catch(Exception e){
            e.printStackTrace();
        }
    }

}

