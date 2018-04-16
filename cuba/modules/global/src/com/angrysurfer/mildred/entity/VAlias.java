package com.angrysurfer.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import com.angrysurfer.mildred.entity.key.VAliasCompKey;
import javax.persistence.EmbeddedId;
import com.haulmont.cuba.core.entity.BaseGenericIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "v_alias")
@Entity(name = "mildred$VAlias")
public class VAlias extends BaseGenericIdEntity<VAliasCompKey> {
    private static final long serialVersionUID = 3764716278272731240L;

    @EmbeddedId
    protected VAliasCompKey id;

    @Override
    public VAliasCompKey getId() {
        return id;
    }

    @Override
    public void setId(VAliasCompKey id) {
        this.id = id;
    }


}