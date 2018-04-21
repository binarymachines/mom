package com.angrysurfer.mildred.entity.media;

import javax.persistence.Entity;
import javax.persistence.Table;
import com.haulmont.cuba.core.global.DesignSupport;
import javax.persistence.Column;
import com.haulmont.cuba.core.entity.BaseIntIdentityIdEntity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import com.haulmont.cuba.core.entity.annotation.Lookup;
import com.haulmont.cuba.core.entity.annotation.LookupType;

@DesignSupport("{'imported':true,'unmappedColumns':['directory_type_id']}")
@Table(name = "directory_pattern")
@Entity(name = "mildred$DirectoryPattern")
public class DirectoryPattern extends BaseIntIdentityIdEntity {
    private static final long serialVersionUID = 3624807172080318531L;

    @Column(name = "pattern", nullable = false, length = 256)
    protected String pattern;

    @Lookup(type = LookupType.DROPDOWN, actions = {"lookup", "open"})
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "directory_type_id")
    protected DirectoryType directoryType;

    public void setDirectoryType(DirectoryType directoryType) {
        this.directoryType = directoryType;
    }

    public DirectoryType getDirectoryType() {
        return directoryType;
    }


    public void setPattern(String pattern) {
        this.pattern = pattern;
    }

    public String getPattern() {
        return pattern;
    }


}