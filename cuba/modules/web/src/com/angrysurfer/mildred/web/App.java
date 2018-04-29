package com.angrysurfer.mildred.web;

import com.haulmont.cuba.web.DefaultApp;

import javax.inject.Inject;

public class App extends DefaultApp {

    @Override
    protected String routeTopLevelWindowId() {
        return "mainWindow";
    }
}