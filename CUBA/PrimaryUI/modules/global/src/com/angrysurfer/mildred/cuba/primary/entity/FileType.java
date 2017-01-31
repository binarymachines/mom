package com.angrysurfer.mildred.cuba.primary.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "file_type")
@Entity(name = "primary$FileType")
public class FileType extends BaseIdentityIdEntity {
    private static final long serialVersionUID = -3174110058170281791L;

    @Column(name = "name", nullable = false, length = 25)
    protected String name;

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }


}