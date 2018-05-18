package com.angrysurfer.mildred.web.media.asset


import com.haulmont.cuba.gui.components.*;

import com.haulmont.cuba.gui.data.DataSupplier;
import com.haulmont.cuba.gui.data.Datasource;

import com.haulmont.cuba.gui.components.AbstractEditor
import com.angrysurfer.mildred.entity.media.Asset

import javax.inject.Inject;

class AssetEdit extends AbstractEditor<Asset> {

    @Inject
    private Label documentLabel
    
    @Override
    protected void postInit() {
        super.postInit();
        String q = '"'
        if (getItem().assetType) {
            String req = "http://localhost:9200/${getItem().assetType}/_search?pretty;q=_id:$q${getItem().id}$q"
            documentLabel.setValue(req)
            String doc = req.toURL().text
            getItem().setDocument(doc)
        }

//        if (getItem().path) {
//            String req = "file:///$q${getItem().path}$q"
//            documentLabel.setValue(req)
//            String doc = req.toURL().text
//            getItem().setDocument(doc)
//        }
    }
}