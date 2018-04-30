package com.angrysurfer.mildred.web.media.asset


import com.haulmont.cuba.gui.components.SourceCodeEditor;
import com.haulmont.cuba.gui.components.SourceCodeEditor.Mode;

import com.haulmont.cuba.gui.data.DataSupplier;
import com.haulmont.cuba.gui.data.Datasource;

import com.haulmont.cuba.gui.components.AbstractEditor
import com.angrysurfer.mildred.entity.media.Asset

import javax.inject.Inject;

class AssetEdit extends AbstractEditor<Asset> {

    @Inject
    private SourceCodeEditor codeEditor;

    @Override
    protected void postInit() {
        super.postInit();
        if (getItem().assetType) {
            String doc = "http://localhost:9200/${getItem().assetType}/_search?pretty;q=_id:'${getItem().id}''".toURL().text
            getItem().setDocument(doc)
        }
    }
}