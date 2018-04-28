package com.angrysurfer.mildred.web.media.asset


import com.haulmont.cuba.gui.components.*;
import com.haulmont.cuba.gui.data.DataSupplier;
import com.haulmont.cuba.gui.data.Datasource;

import com.haulmont.cuba.gui.components.AbstractEditor
import com.angrysurfer.mildred.entity.media.Asset

import javax.inject.Inject;

class AssetEdit extends AbstractEditor<Asset> {

    // @Inject
    // private SourceCodeEditor sourceCodeEditor;

    @Override
    protected void postInit() {
        super.postInit();
        if (getItem()) {
            String doc = "http://localhost:9200/${getItem().assetType}/_search?q=_id:${getItem().id}".toURL().text
            getItem().setDocument(doc)
        }
    }
}