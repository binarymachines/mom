package com.angrysurfer.mildred.entity;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "directory_constant")
@Entity(name = "mildred$DirectoryConstant")
public class DirectoryConstant extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = -9038552652011847297L;

    @Column(name = "pattern", nullable = false, length = 256)
    protected String pattern;

    @Column(name = "location_type", nullable = false, length = 64)
    protected String locationType;

    public void setPattern(String pattern) {
        this.pattern = pattern;
    }

    public String getPattern() {
        return pattern;
    }

    public void setLocationType(String locationType) {
        this.locationType = locationType;
    }

    public String getLocationType() {
        return locationType;
    }


}