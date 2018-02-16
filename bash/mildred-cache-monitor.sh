#!/usr/bin/env bash

pushd $MILDRED_HOME/java/MildredCacheMonitor

mvn -e exec:java -Dexec.mainClass="com.angrysurfer.mildred.ui.javafx.MildredMonitorStage" &
mvn -e exec:java -Dexec.mainClass="com.angrysurfer.mildred.ui.swing.MildredMonitorFrame" &
sudo popd
