package com.angrysurfer.mildred.entity.media;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "category")
@Entity(name = "mildred$Category")
public class Category extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -3707041010922601317L;

    @Column(name = "name", nullable = false, length = 256)
    protected String name;

    @Column(name = "asset_type", nullable = false, length = 128)
    protected String assetType;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setAssetType(String assetType) {
        this.assetType = assetType;
    }

    public String getAssetType() {
        return assetType;
    }


}