package com.angrysurfer.mildred.entity.media;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;

@DesignSupport("{'imported':true}")
@Table(name = "directory_constant")
@Entity(name = "mildred$DirectoryConstant")
public class DirectoryConstant extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 4730570359723533034L;

    @Column(name = "pattern", nullable = false, length = 256)
    protected String pattern;

    @Column(name = "directory_type", nullable = false, length = 64)
    protected String directoryType;

    public void setPattern(String pattern) {
        this.pattern = pattern;
    }

    public String getPattern() {
        return pattern;
    }

    public void setDirectoryType(String directoryType) {
        this.directoryType = directoryType;
    }

    public String getDirectoryType() {
        return directoryType;
    }


}