package com.angrysurfer.mildred.entity.media;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.chile.core.annotations.NamePattern;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@NamePattern("%s|name")
@Table(name = "file_type")
@Entity(name = "mildred$FileType")
public class FileType extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -9197928740428993564L;

    @Column(name = "name", length = 25)
    protected String name;

    @Column(name = "ext", length = 11)
    protected String ext;

    public void setExt(String ext) {
        this.ext = ext;
    }

    public String getExt() {
        return ext;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }


}